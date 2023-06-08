namespace elsa {

    public class module_rsync : module {
        private string source;
        private string target;
        public string[] excludes;
        public void init(){
            this.main.connect(rsync_main);
            excludes = {"dev/*","proc/*","tmp/*","run/*","mnt/*","media/*","lost+found"};
        }
        
        public void set_source(string path){
            source = path;
        }
    
        public void set_target(string path){
            target = path;
        }
    
        private long get_inode_size(string path){
            string dfout = elsa.cmd.getoutput({"df","--inodes", path});
            stdout.printf("%s\n",ssplit(dfout," ")[2]);
            return long.parse(ssplit(dfout," ")[2]);
        }
        
        public int rsync_main(){
            command cmd = new command();
            long current = 0;
            long total = get_inode_size("/%s".printf(source));
            cmd.update.connect((line)=>{
                int percent = (int)(100*current/total);
                elsa.do_update(percent,line,false);
                current += 1;
            });
            string[] rsync_cmd = {
                "rsync",
                "--verbose",
                "--archive",
                "--no-D",
                "--acls",
                "--hard-links",
                "--xattrs",
                "--exclude="+source,
                "--exclude="+target
            };
            foreach(string e in excludes){
                rsync_cmd += "--exclude="+e;
            }
            rsync_cmd += source+"/*";
            rsync_cmd += target+"/";
            bool finish = false;
            cmd.done.connect(()=>{
                finish=true;
            });
            foreach(string e in rsync_cmd){
                stdout.printf("%s\n",e);
            }
            cmd.run_and_update(rsync_cmd);
            while(!finish){
                GLib.Thread.usleep(200);
            }
            return 0;
        }
    }
}