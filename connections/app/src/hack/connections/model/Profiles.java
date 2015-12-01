package hack.connections.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Profiles {

    String macAddr;
    Item[] items;

    public Profiles() {
        // Jackson deserialization
    }

    public Profiles(String macAddr, Item[] items) {
        this.macAddr = macAddr;
        this.items = items;
    }

    @JsonProperty
    public String getMacAddr() {
        return this.macAddr;
    }

    @JsonProperty
    public Item[] getItems() {
        return this.items;
    }

    public enum ItemKind {
        ANONYMOUS,
        LINKEDIN,
        FACEBOOK,
        GOOGLEPLUS
    }

    public static class Item {

        ItemKind kind;
        String iconURL;
        String text;

        public Item(ItemKind kind, String iconURL, String text) {
            this.kind = kind;
            this.iconURL = iconURL;
            this.text = text;
        }

        @JsonProperty
        public ItemKind getKind() {
            return this.kind;
        }

        @JsonProperty
        public String getIconURL() {
            return this.iconURL;
        }

        @JsonProperty
        public String getText() {
            return this.text;
        }
    }

}
