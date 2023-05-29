namespace elsa {
    public class elsa{
        private module[] modules;
        private string[] errors;
        public signal void update(int percent, string line, bool pulse);
        public signal void done(int status);
        public void add_module(module m){
            if(modules == null){
                modules = {};
            }
            m.update.connect((a, b, c)=>{
                 update(a, b, c);
            });
            modules += m;
        }
        public void set_value(string module, string name, string value){
            foreach(module m in modules){
                if (m.name == module){
                    m.set_value(name,value);
                }
            }
        }
        public string get_value(string module, string name){
            foreach(module m in modules){
                if (m.name == module){
                    return m.get_value(name);
                }
            }
            return "";
        }
        
        public bool has_error(){
            return errors.length != 0;
        }
        public void add_error(string msg){
            if(errors == null){
                errors = {};
            }
            errors += msg;
        }
        private bool operation_started = false;
        private void run_operation(){
            if(operation_started){
                return;
            }
            operation_started = true;
            int status = 0;
            foreach(module m in modules){
                status = m.run();
                if(status != 0){
                    done(status);
                }
            }
            done(0);
            operation_started = false;
        }
        public void run(){
            new Thread<void> ("run", run_operation);
        }
    }
}
