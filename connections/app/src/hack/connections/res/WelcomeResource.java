package hack.connections.res;

import hack.connections.model.Device;
import hack.connections.views.WelcomeView;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/")
@Produces(MediaType.TEXT_HTML)
public class WelcomeResource {

    final static Device VOID = new Device();

    public WelcomeResource() {
        VOID.setMacAddr("void");
    }

    @GET
    public WelcomeView welcome() {
        return new WelcomeView(VOID);
    }
}
