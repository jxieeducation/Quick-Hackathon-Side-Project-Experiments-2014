package hack.connections.cmx;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import sun.net.util.IPAddressUtil;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.zip.GZIPInputStream;

public class CMXWatcher implements Runnable {

    private static final Logger LOG = LoggerFactory.getLogger(CMXWatcher.class);
    private boolean terminate = false;
    private static final File TEST_DIR = new File("test");

    @Override
    public void run() {
            if (terminate)
                return;
        try {
            XMLInputFactory factory = XMLInputFactory.newFactory();
            String[] files = TEST_DIR.list((dir1, name) -> name.startsWith("clients-") && name.endsWith(".xml.gz"));

            for (String file : files) {
                if (terminate)
                    break;
                XMLStreamReader reader = factory.createXMLStreamReader(new GZIPInputStream(new FileInputStream(new File(TEST_DIR, file))));
                String text = null;

                String macAddr = null;
                String ipv4 = null;
                Double confidenceFactor = null;
                Double latitude = null;
                Double longitude = null;
                Long firstLocated = null;
                Long lastLocated = null;

                while (reader.hasNext()) {
                    switch (reader.next()) {
                        case XMLStreamConstants.START_ELEMENT:
                            switch (reader.getLocalName()) {
                                // e.g. <WirelessClientLocation ipAddress="10.10.30.35 fe80:0000:0000:0000:659f:a68c:3dda:d3ad" ssId="DevNetZone" band="UNKNOWN" apMacAddress="1c:e6:c7:0d:d9:90" isGuestUser="false" dot11Status="ASSOCIATED" macAddress="6c:88:14:bc:b0:74" currentlyTracked="true" confidenceFactor="24.0">
                                case "WirelessClientLocation":
                                    for (int i = 0; i < reader.getAttributeCount(); i++) {
                                        switch (reader.getAttributeName(i).getLocalPart()) {
                                            case "macAddress":
                                                macAddr = reader.getAttributeValue(i);
                                                break;
                                            case "confidenceFactor":
                                                confidenceFactor = Double.valueOf(reader.getAttributeValue(i));
                                                break;
                                            case "ipAddress":
                                                // take the first entry that looks like an ipv4 addr
                                                for (String part : reader.getAttributeValue(i).split(" ")) {
                                                    if (IPAddressUtil.isIPv4LiteralAddress(part)) {
                                                        ipv4 = part;
                                                        break;
                                                    }
                                                }
                                        }
                                    }
                                    break;
                                case "Statistics":
                                    for (int i = 0; i < reader.getAttributeCount(); i++) {
                                        switch (reader.getAttributeName(i).getLocalPart()) {
                                            case "firstLocatedTime":
                                                firstLocated = parseCMXTime(reader.getAttributeValue(i));
                                                break;
                                            case "lastLocatedTime":
                                                lastLocated = parseCMXTime(reader.getAttributeValue(i));
                                                break;
                                        }
                                    }
                                    break;
                                case "GeoCoordinate":
                                    for (int i = 0; i < reader.getAttributeCount(); i++) {
                                        switch (reader.getAttributeName(i).getLocalPart()) {
                                            case "lattitude":
                                            case "latitude":
                                                latitude = Double.valueOf(reader.getAttributeValue(i));
                                                break;
                                            case "longitude":
                                                longitude = Double.valueOf(reader.getAttributeValue(i));
                                                break;
                                        }
                                    }
                                    if (latitude == null || longitude == null) {
                                        LOG.warn("incomplete coordinates");
                                        break;
                                    }
                                    break;
                            }
                            break;
                        case XMLStreamConstants.END_ELEMENT:
                            switch (reader.getLocalName()) {
                                case "WirelessClientLocation":
                                    CMXClientLocationEvent.Tracker.registerEvent(new CMXClientLocationEvent(macAddr, lastLocated, latitude, longitude));
                                    // reset
                                    macAddr = null;
                                    ipv4 = null;
                                    lastLocated = null;
                                    latitude = null;
                                    longitude = null;
                                    break;
                            }
                            break;
                    }
                }
            }
            Thread.sleep(1000);
        } catch (XMLStreamException | IOException | InterruptedException e) {
            LOG.error(e.getMessage());
        }
    }

    // e.g. 2014-05-20T13:01:18.973-0700
    private final static DateTimeFormatter CMX_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'kk:mm:ss.SSSX");

    private static long parseCMXTime(String str) {
        return LocalTime.parse(str, CMX_TIME_FORMAT).toNanoOfDay() / 1000000; // FIXME: should be epoch seconds
    }

    public void stop() {
        this.terminate = true;
    }

}
