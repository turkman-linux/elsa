int main(string[] args){
    load_config("/etc/debian.conf");
    // mount
    if(0 != mount_main(args)){
        return 1;
    }
    return 0;
}
