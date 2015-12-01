package hack.connections;

import hack.connections.cmx.CMXWatcher;
import hack.connections.cmx.CMXWatcherManager;
import hack.connections.res.MatchesResource;
import hack.connections.res.ProfilesResource;
import hack.connections.res.WelcomeResource;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import io.dropwizard.views.ViewBundle;

public class ConnectionsApp extends Application<ConnectionsConfiguration> {

    public static void main(String[] args) throws Exception {
        new ConnectionsApp().run(args);
    }

    @Override
    public String getName() {
        return "connections-app";
    }

    @Override
    public void initialize(Bootstrap<ConnectionsConfiguration> bootstrap) {
        bootstrap.addBundle(new ViewBundle());
    }

    @Override
    public void run(ConnectionsConfiguration conf, Environment env) {
        env.healthChecks().register("template", new AppHealthCheck(conf.getTemplate()));

//        final DBIFactory factory = new DBIFactory();
//        final DBI jdbi = factory.build(env, conf.getDataSourceFactory(), "postgresql");
//        final UserDAO dao = jdbi.onDemand(UserDAO.class);
//        environment.jersey().register(new UserResource(dao));

        env.jersey().register(new MatchesResource());
        env.jersey().register(new ProfilesResource());
        env.jersey().register(new WelcomeResource());

        env.lifecycle().manage(new CMXWatcherManager(new CMXWatcher()));

    }

}