public int rsync_main(string[] args){
    return run_args({
        "rsync",
        "-av",
        "/source",
        "/target"
    });
}
