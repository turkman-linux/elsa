namespace elsa{
    public class elsa{
        private module[] modules;
        private string[] errors;
        public signal void update(int percent, string line, bool pulse);
        public void add_module(module m){
            if(modules == null){
                modules = {};
            }
            m.update.connect((a, b, c)=>{
                 update(a, b, c);
            });
            modules += m;
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
        public int run(){
             GLib.MainLoop loop = new GLib.MainLoop();
             GLib.Idle.add(()=>{
                 foreach(module m in modules){
                     m.run();
                 }
                 loop.quit();
                 return false;
            });
            loop.run();
            return 0;
        }
    }
}
