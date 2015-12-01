package hack.connections.views;

import hack.connections.model.Device;
import io.dropwizard.views.View;

public class WelcomeView extends View {

    private final Device device;

    public WelcomeView(Device device) {
        super("WelcomeView.mustache");
        this.device = device;
    }

    public Device getDevice() {
        return device;
    }

}
