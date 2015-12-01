package hack.connections.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import java.util.HashSet;

@Entity
@Table(name = "devices")
@NamedQueries({
        @NamedQuery(
                name = "hack.connections.model.Device.findAll",
                query = "SELECT d FROM Device d"
        ),
        @NamedQuery(
                name = "hack.connections.model.Device.findByMacAddress",
                query = "SELECT d FROM Device d WHERE d.macaddr = :macaddr"
        )
})
public class Device {

    @Id
    private String macAddr; // String lame but easy yo

    private HashSet<String> ipAddrs;

    private String lastSeenIpAddr;

    private long lastSeenWhen;

    @Column(name = "visibleName", nullable = true)
    private String visibleName;

    public String getMacAddr() {
            return macAddr;
        }

    public void setMacAddr(String macAddr) {
            this.macAddr = macAddr;
        }

    public String getVisibleName() {
        return visibleName != null ? visibleName : String.format("ip-%s", lastSeenIpAddr);
    }

    public void setVisibleName(String visibleName) {
            this.visibleName = visibleName;
        }

    public void seenIpAddr(String ipAddr) {
        lastSeenIpAddr = ipAddr;
        lastSeenWhen = System.currentTimeMillis();
    }

}
