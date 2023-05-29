namespace elsa {
    public class module {
        private config[] cfg;
        public signal int init();
        public signal int main();
        private string name;
        public bool enabled = true;
        public signal void update(int percent, string line, bool pulse);
        public module(string n){
           name = n;
           cfg = {};
        }
        public int run(){
            if(enabled){
                return main();
            }
            return 0;
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
