public class module {
    public string name;
    public signal int callback(string[] args);
}
private module[] modules;

public void add_module(module m){
    if(modules == null){
        modules = {};
    }
    modules += m;
}

public int run_module(string name, string[] args){
    foreach(module m in modules){
        stdout.printf("%s %s\n",m.name, name);
        if(m.name == name){
            return m.callback(args);
        }
    }return 0;
}
