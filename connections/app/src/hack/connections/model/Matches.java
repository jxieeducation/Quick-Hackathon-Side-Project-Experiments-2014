package hack.connections.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Matches {

    String macAddr;
    Object[][] matches;

    public Matches() {
        // Jackson deserialization
    }

    public Matches(String macAddr, Object[][] matches) {
        this.macAddr = macAddr;
        this.matches = matches;
    }

    @JsonProperty
    public String getMacAddr() {
        return this.macAddr;
    }

    @JsonProperty
    public Object[][] getMatches() {
        return this.matches;
    }
}