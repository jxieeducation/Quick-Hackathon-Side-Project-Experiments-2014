package hack.connections.cmx;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CMXClientLocationEvent {

    private String macAddr;
    private long time;
    private double lat;
    private double lng;

    public CMXClientLocationEvent(String macAddr, long time, double lat, double lng) {
        this.macAddr = macAddr;
        this.time = time;
        this.lat = lat;
        this.lng = lng;
    }

    public double distance(CMXClientLocationEvent other) {
        long dtime = Math.abs(this.time - other.time);
        if (dtime > 120) // TODO: exponential falloff rather than hard limit
            return Double.MAX_VALUE;

        double dlat = Math.abs(this.lat - other.lat);
        double dlng = Math.abs(this.lng - other.lng);
        return Math.sqrt(Math.pow(dlat, 2) + Math.pow(dlng, 2));
    }

    public String toString() {
        return String.format("CLE[macaddr=%s at (%s,%s) time=%s]", macAddr, lat, lng, time);
    }

    public static class Tracker {

        private static HashMap<String, List<CMXClientLocationEvent>> events = new HashMap<>();

        public static void registerEvent(CMXClientLocationEvent ev) {
            List<CMXClientLocationEvent> list = events.get(ev.macAddr);
            if (list == null) {
                list = new ArrayList<>();
                events.put(ev.macAddr, list);
            }
            list.add(ev);
        }

        /**
         * @return array of tuple of distance metric and device
         */
        public static Object[][] getTopNEncounters(String macAddr, int count) {
            // FIXME: n^2 won't scale

            HashMap<String, Double> scores = new HashMap<>();
            ArrayList<CMXClientLocationEvent> self = new ArrayList<>();
            self.addAll(events.get(macAddr));

            for (Map.Entry<String, List<CMXClientLocationEvent>> ev: events.entrySet()) {
                if (ev.getKey().equals(macAddr)) // don't compare with self
                    continue;
                for (CMXClientLocationEvent s : self) {
                    for (CMXClientLocationEvent o : ev.getValue()) {
                        double distance = s.distance(o);
                        Double score = scores.get(o.macAddr);
                        if (score == null) {
                            scores.put(o.macAddr, (1 / distance));
                        } else {
                            if (distance == Double.MAX_VALUE)
                                continue;
                            scores.put(o.macAddr, score + (1 / distance)); // TODO: sum of distances not a good metric
                        }
                    }
                }
            }

            Object[][] ranked = new Object[scores.size()][];
            int i = 0;
            for (Map.Entry<String, Double> e : scores.entrySet()) {
                ranked[i++] = new Object[] { e.getKey(), e.getValue() };
            }
            Arrays.sort(ranked, (o1, o2) -> Double.compare((double) o2[1], (double) o1[1]));

            if (ranked.length <= count)
                return ranked;

            Object[][] rankedN = new Object[count][];
            System.arraycopy(ranked, 0, rankedN, 0, count);
            return rankedN;
        }
    }
}
