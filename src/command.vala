public int run_args(string[] args) {
            try {
                string[] spawn_env = Environ.get ();
                int status;
                Process.spawn_sync ("/",
                                args,
                                spawn_env,
                                SpawnFlags.SEARCH_PATH,
                                null,
                                null,
                                null,
                                out status);

                return status;
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
            }
            return 1;
        }
