public int mount_main(string[] args){
    int status = 0;
    // Mount source
    status = run_args({
        "mount",
        get_value("mount","source","/dev/loop0"),
        "/source"
    });
    if(status != 0){
        print ("Error: %s\n", "Failed to mount source");
        return status;
    }
    // Mount source
    status = run_args({
        "mount",
        get_value("mount","target","/dev/null"),
        "/target"
    });
    if(status != 0){
        print ("Error: %s\n", "Failed to mount target");
        return status;
    }
    return 0;
}

