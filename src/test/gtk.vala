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
    e.update.connect((percent, line, pulse)=>{
        stdout.printf("%d %s\n", percent, line);
        l.set_label("%s".printf(line));
    });
    e.done.connect(()=>{
        stderr.printf("done\n");
    });
    // create test module
    var m = new elsa.module();
    m.name = "hello-world";
    m.main.connect(()=>{
        //system("sleep 3");
        e.do_update(0,m.get_value("text"),false);
        return 0;
    });
    // add elsa module
    e.add_module(m);
    e.set_value("hello-world","text","Hello World\n");
    
    // rsync module
    var rsync = new elsa.module_rsync();
    rsync.name = "rsync";
    rsync.init();
    rsync.set_source("/mnt");
    rsync.set_target("/home/a/test");
    e.add_module(rsync);
    // connect signal
    l.clicked.connect((w)=>{
        GLib.Idle.add((GLib.SourceFunc)e.run);
    });
    e.cmd.done.connect(()=>{
        stdout.printf("DONE\n");
    });
    Gtk.main();
    return 0;
}

