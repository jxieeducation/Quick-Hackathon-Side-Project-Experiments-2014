package hack.connections.cmx;

import io.dropwizard.lifecycle.Managed;

public class CMXWatcherManager implements Managed {

        private final CMXWatcher cmx;

        public CMXWatcherManager(CMXWatcher cmx) {
            this.cmx = cmx;
        }

        @Override
        public void start() throws Exception {
            cmx.run();
        }

        @Override
        public void stop() throws Exception {
            cmx.stop();
        }
}
