public extern int system(string cmd);
int main(string[] args){
    // create window and test gtk widgets
    Gtk.init(ref args);
    var w = new Gtk.Window();
    var l = new Gtk.Button();
    w.add(l);
    w.show_all();

    // create elsa engine
    elsa.engine e = new elsa.engine();
    // connect elsa engine with gtk
    int i=0;
    e.update.connect((percent, line, pulse)=>{
        l.set_label(line+i.to_string());
        i+=1;
    });
    e.done.connect(()=>{
        stderr.printf("done\n");
    });
    // create test module
    var m = new elsa.module();
    m.name = "hello-world";
    m.main.connect(()=>{
        system("sleep 3");
        e.do_update(0,m.get_value("text"),false);
        return 0;
    });
    // add elsa module
    e.add_module(m);
    e.set_value("hello-world","text","Hello World\n");
    // connect signal
    l.clicked.connect((w)=>{
        e.run();
    });
    Gtk.main();
    return 0;
}

