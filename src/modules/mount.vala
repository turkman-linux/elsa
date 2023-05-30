namespace elsa {
    private class mount_object {
        public string disk;
        public string target;
    }
    public class module_mount : module {
        private mount_object[] obj;
        public void init(){
            name = "mount";
            obj = {};
            this.main.connect(mount_main);
        }
        public void add_mount(string disk, string target){
            var o = new mount_object();
            o.disk = disk;
            o.target = target;
            obj += o;
        }
        private int mount_main(){
            sort();
            foreach(mount_object o in obj){
                stdout.printf("%s %s\n",o.disk, o.target);
            }
            return 0;
        }
        private void sort(){
            mount_object[] nobj = {};
            int cur = 0;
            while(true){
                foreach(mount_object o in obj){
                    if(o.target.length == cur){
                        nobj += o;
                    }
                }
                cur += 1;
                if(nobj.length == obj.length){
                    obj = nobj;
                    return;
                }
            }
        }
    }
}