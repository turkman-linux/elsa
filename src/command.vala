namespace elsa {

    public class command {
    public signal void update(string output);
    public signal void done();
    private bool process_line (IOChannel channel, IOCondition condition, string stream_name) {
	    if (condition == IOCondition.HUP) {
	        done();
                return false;
	    }

            try {
                string line;
                channel.read_line (out line, null, null);
                do_update(line);
            } catch (IOChannelError e) {
                print ("%s: IOChannelError: %s\n", stream_name, e.message);
                return false;
            } catch (ConvertError e) {
                print ("%s: ConvertError: %s\n", stream_name, e.message);
                return false;
            }
            return true;
        }
        private void do_update(string line){
            update(line);
        }

        public void run_and_update(string[] args){
            Pid child_pid;
            int standard_input;
            int standard_output;
            int standard_error;
            string[] spawn_env = Environ.get ();
            try {
                GLib.Process.spawn_async_with_pipes ("/",
                    args,
                    spawn_env,
                    SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
                    null,
                    out child_pid,
                    out standard_input,
                    out standard_output,
                    out standard_error);
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
            }       
            // stdout
            GLib.IOChannel output = new GLib.IOChannel.unix_new (standard_output);
            output.add_watch (GLib.IOCondition.IN | GLib.IOCondition.HUP, (channel, condition) => {
                return process_line (channel, condition, "stdout");
            });
            // stderr:
            GLib.IOChannel error = new GLib.IOChannel.unix_new (standard_error);
                error.add_watch (GLib.IOCondition.IN | GLib.IOCondition.HUP, (channel, condition) => {
                return process_line (channel, condition, "stderr");
            });

            GLib.ChildWatch.add (child_pid, (pid, status) => {
                GLib.Process.close_pid (pid);
            });
        }
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
        public string getoutput(string[] args) {
            try {
                string[] spawn_env = Environ.get ();
                string output;
                Process.spawn_sync ("/",
                                args,
                                spawn_env,
                                SpawnFlags.SEARCH_PATH,
                                null,
                                out output,
                                null,
                                null);

                return output;
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
            }
            return "";
        }
    }
}