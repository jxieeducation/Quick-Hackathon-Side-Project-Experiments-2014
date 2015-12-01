package hack.connections.res;

import com.codahale.metrics.annotation.Timed;
import com.google.common.base.Optional;
import hack.connections.cmx.CMXClientLocationEvent;
import hack.connections.model.Matches;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

@Path("/matches")
@Produces(MediaType.APPLICATION_JSON)
public class MatchesResource {

    public MatchesResource() {
    }

    @GET
    @Timed
    public Matches showMatches(@QueryParam("macAddr") Optional<String> macAddr, @QueryParam("count") Optional<Integer> count) {
        final String key = macAddr.or("68:9c:70:e4:54:7f");
        final Integer n = count.or(10);
        Object[][] matches = CMXClientLocationEvent.Tracker.getTopNEncounters(key, n);
        return new Matches(key, matches);
    }
}