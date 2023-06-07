namespace elsa {
    public class engine : GLib.Object{
        private module[] modules;
        private string[] errors;
        public signal void update(int percent, string line, bool pulse);
        public signal void error(string line, bool fatal);
        public signal void done(int status);

        public void do_update(int percent, string line, bool pulse){
            update(percent, line, pulse);
        }
        public void do_error(string line, bool fatal){
            error(line, fatal);
        }
        // module insert
        public void add_module(module m){
            if(modules == null){
                modules = {};
            }
            if(m.name == "" || m.name == null){
                return;
            }
            m.update.connect((a, b, c)=>{
                 update(a, b, c);
            });
            m.set_engine(this);
            debug("Module register: "+m.name);
            modules += m;
        }
        // value functions
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
        // error functions
        public bool has_error(){
            return errors.length != 0;
        }
        public void add_error(string msg){
            if(errors == null){
                errors = {};
            }
            errors += msg;
        }
        // operation functions
        private bool operation_started = false;
        private void run_operation(){
            if(operation_started){
                return;
            }
            operation_started = true;
            int status = 0;
            // order modules
            string[] mod_names = {};
            foreach(module m in modules){
                mod_names += m.name;
            }
            module_order = {};
            module_cache = {};
            resolve_dependency(mod_names);
            foreach(string name in module_order){
                var m = get_module(name);
                debug("Run module: "+m.name);
                status = m.run();
                if(status != 0){
                    done(status);
                }
            }
            if(has_error()){
                foreach(string err in errors){
                    do_error(err,true);
                }
            }
            done(0);
            operation_started = false;
        }
        public void run(){
            new Thread<void> ("run", run_operation);
        }
        // module order resolver
        private module get_module(string name){
            if(name == null){
                return new module();
            }
            foreach(module m in modules){
                if(m.name == name){
                    return m;
                }
            }
            return new module();
        }
        private string[] module_order;
        private string[] module_cache;
        private void resolve_dependency(string[] names){
            foreach(string name in names){
                if(name in module_cache){
                    continue;
                }
                module_cache += name;
                var m = get_module(name);
                if(m != null){
                    if(m.get_deps().length > 0){
                        resolve_dependency(m.get_deps());
                    }
                    module_order += name;
                }
            }
        }
    }
}
