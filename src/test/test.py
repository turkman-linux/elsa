import gi
gi.require_version("elsa","1.0")
from gi.repository import elsa, GLib
loop = GLib.MainLoop()

# create elsa engine
e = elsa.engine()

# connect update signal
def update(engine, percent, line, pulse):
    print(line)
def error(engine, line, fatal):
    print(line)
def done(engine, status):
    exit(0)
e.connect("update",update)
e.connect("error",error)
e.connect("done",done)

# create test module
def main(engine):
    engine.do_update(0,"hello world",False)
    return 0
m = elsa.module()
m.name = "hello-world"
m.connect("main",main)
# add elsa module
e.add_module(m)

# command test
def uuu(c,msg):
    print(msg)
e.cmd.connect("update",uuu)
e.cmd.run_args(["uname","-m"]);
e.cmd.run_and_update(["uname","-m"]);
e.cmd.getoutput(["uname","-m"]);

# mount module test
mount = elsa.module_mount()
mount.init()
print(mount.name)
e.add_module(mount)
mount.add_mount("/dev/sda1","/boot/efi")
mount.add_mount("/dev/sda2","/")

e.run()
loop.run()
