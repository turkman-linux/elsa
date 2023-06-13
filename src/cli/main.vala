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
    e.cmd = new elsa.command();
    e.cmd.update.connect((line)=>{
        e.do_update(0,line,false);
    });
    // create test module
    var m = new elsa.module();
    m.name = "hello-world";
    m.main.connect(()=>{
        e.cmd.run_and_update({"ls","/"});
        e.do_update(0,"hello world\n",false);
        return 0;
    });
    // add elsa module
    e.add_module(m);
    e.run();
    loop.run();
    return 0;
}

