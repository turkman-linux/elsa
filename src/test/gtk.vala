public extern int system(string cmd);
int main(string[] args){
    // create window and test gtk widgets
    Gtk.init(ref args);
    var w = new Gtk.Window();
    var l = new Gtk.Button();
    w.add(l);
    w.show_all();

    // create elsa engine
    elsa.elsa e = new elsa.elsa();
    // connect elsa engine with gtk
    int i=0;
    e.update.connect((percent, line, pulse)=>{
        l.set_label(percent+i.to_string());
        i+=1;
    });
    e.done.connect(()=>{
        stderr.printf("done\n");
    });
    // create test module
    var m = new elsa.module("hello-world");
    m.main.connect(()=>{
        system("sleep 3");
        m.update(0,"hello world\n",false);
        return 0;
    });
    // add elsa module
    e.add_module(m);
    // connect signal
    l.clicked.connect((w)=>{
        e.run();
    });
    Gtk.main();
    return 0;
}

