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
