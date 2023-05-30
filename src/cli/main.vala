public extern int system(string cmd);
int main(string[] args){
    var loop = new GLib.MainLoop();
    // create elsa engine
    elsa.engine e = new elsa.engine();
    // connect update signal
    e.update.connect((percent, line, pulse)=>{
        stdout.printf(line);
    });
    e.done.connect(()=>{
        loop.quit();
    });
    // create test module
    var m = new elsa.module("hello-world");
    m.main.connect(()=>{
        m.update(0,"hello world\n",false);
        return 0;
    });
    // add elsa module
    e.add_module(m);
    e.run();
    loop.run();
    return 0;
}

