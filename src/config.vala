class config {
    public string name="";
    public string value="";
    public string section="";
}

private config[] cfg;

public void load_config(string file){
    cfg = {};
    string data = readfile(file);
    string cursec = "main";
    foreach(string line in data.split("\n")){
        line = line.strip();
        if(line[0] == '[' && line[line.length-1] == ']'){
            cursec = line[1:-1];
            continue;
        }
        if(line[0] == '#'){
            continue;
        }
        if("=" in line){
            config c = new config();
            c.section = cursec;
            c.name = line.split("=")[0];
            c.value = line[c.name.length+1:];
            cfg += c;
        }
    }
}

public string get_value(string section, string name, string default){
    foreach(config c in cfg){
        if(c.section == section && c.name == name){
            return c.value;
        }
    }
    return default;
}

public bool get_bool(string section, string name, bool default){
    return get_value(section, name, default.to_string()) == "true";
}

public string[] get_value_list(string section){
    string[] ret = {};
    foreach(config c in cfg){
        if(c.section == section){
            ret += c.name;
        }
    }
    return ret;
}

public string[] get_section_list(){
    string[] ret = {};
    foreach(config c in cfg){
        if(!(c.section in ret)){
            ret += c.section;
        }
    }
    return ret;
}
