namespace elsa {
    public void writefile(string path, string ctx){
        try {
            var file = File.new_for_path (path);
            if (file.query_exists ()) {
                file.delete ();
            }
            var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
            uint8[] data = ctx.data;
            long written = 0;
            while (written < data.length) {
                written += dos.write (data[written:data.length]);
            }
        } catch (Error e) {
            stderr.printf(e.message);
        }
    }
    public string readfile(string path){
        File file = File.new_for_path (path);
        try {
            FileInputStream @is = file.read ();
            DataInputStream dis = new DataInputStream (@is);
            string data="";
            string line;
            while ((line = dis.read_line ()) != null) {
                data += line+"\n";
            }
            return data;
        } catch (Error e) {
            print ("Error: %s\n", e.message);
        }
        return "";
    }
    public string[] ssplit(string data, string c){
        string[] ret = {};
        foreach(string item in data.split(c)){
            if(item.length > 0){
                ret += item;
            }
        }
        return ret;
    }
}

