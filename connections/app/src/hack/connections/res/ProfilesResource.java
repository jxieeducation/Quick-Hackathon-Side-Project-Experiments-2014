package hack.connections.res;

import com.codahale.metrics.annotation.Timed;
import com.google.common.base.Optional;
import hack.connections.cmx.CMXClientLocationEvent;
import hack.connections.model.Profiles;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.util.Random;

@Path("/profiles")
@Produces(MediaType.APPLICATION_JSON)
public class ProfilesResource {

    private final static String DEMO_MAC = "68:9c:70:e4:54:7f";
    private final static Profiles.ItemKind[] DEMO_PROFILE_KIND = new Profiles.ItemKind[]{
            Profiles.ItemKind.LINKEDIN,
            Profiles.ItemKind.GOOGLEPLUS,
            Profiles.ItemKind.LINKEDIN,
            Profiles.ItemKind.LINKEDIN,
            Profiles.ItemKind.LINKEDIN,
            Profiles.ItemKind.LINKEDIN,
            Profiles.ItemKind.FACEBOOK,
    };

    private final static String[] DEMO_PROFILE_IMG = new String[]{
            "https://media.licdn.com/mpr/mpr/shrink_60_60/p/2/000/1bd/37c/1b5412e.jpg",
            "https://lh5.googleusercontent.com/-s-eTtlW-zxw/AAAAAAAAAAI/AAAAAAAAOk4/tTBS8epQNn0/s70-c-k-no/photo.jpg",
            "https://media.licdn.com/mpr/mpr/shrink_100_100/p/4/000/16a/358/2bfd1b9.jpg",
            "https://media.licdn.com/mpr/mpr/shrink_100_100/p/4/000/16b/195/1b749cf.jpg",
            "https://media.licdn.com/mpr/mpr/shrink_100_100/p/3/000/227/0f3/2756a31.jpg",
            "https://media.licdn.com/mpr/mpr/shrink_100_100/p/2/000/00d/170/091aaf3.jpg",
            "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/t1.0-1/c178.0.604.604/s320x320/252231_1002029915278_1941483569_n.jpg"
    };
    private final static String[] DEMO_PROFILE_TEXT = new String[] {
            "Hunter S.",
            "Barbara L.",
            "Benjamin S.",
            "Janna B.",
            "Hansruedi H.",
            "Jeremy H.",
            "Jason X."
    };
    private final static int DEMO_COUNT = DEMO_PROFILE_IMG.length;

    public ProfilesResource() {
    }

    @GET
    @Timed
    public Profiles showProfiles(@QueryParam("macAddr") Optional<String> macAddr, @QueryParam("count") Optional<Integer> count) {
        final String key = macAddr.or(DEMO_MAC);
        final Integer n = count.or(5);
        Object[][] matches = CMXClientLocationEvent.Tracker.getTopNEncounters(key, n);
        Profiles.Item[] items = new Profiles.Item[matches.length];
        int i = 0;
        int seed = Math.abs(new Random().nextInt());
        for (Object[] match : matches) {
            int mock = (seed + i) % DEMO_COUNT;
            items[i++] = new Profiles.Item(DEMO_PROFILE_KIND[mock], DEMO_PROFILE_IMG[mock], DEMO_PROFILE_TEXT[mock]);
        }
        return new Profiles(key, items);
    }
}