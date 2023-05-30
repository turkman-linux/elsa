namespace elsa {
    public class module : GLib.Object {
        private config[] cfg;
        public signal int init();
        public signal int main();
        private string[] dependency;
        public string name;
        public bool enabled = true;
        public signal void update(int percent, string line, bool pulse);
        public module(string n){
           name = n;
           cfg = {};
        }
        public void do_update(int percent, string line, bool pulse){
            update(percent, line, pulse);
        }
        public int run(){
            if(enabled){
                return main();
            }
            return 0;
        }
        public void set_deps(string[] deps){
            dependency = deps;
        }
        public string[] get_deps(){
            return dependency;
        }
        public void set_value(string name, string value){
             foreach(config c in cfg){
                 if(c.name == name){
                     c.value = value;
                     return;
                 }
             }
             config cn = new config();
             cn.name = name;
             cn.value = value;
             cfg += cn;
             return;
        }
        public string get_value(string name){
            foreach(config c in cfg){
                if(c.name == name){
                    return c.value;
                }
            }
            return "";
        }
    }
}
