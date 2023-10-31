int main(string[] args){
    ctx_init();
    load_config("test.conf");
    run_module("mount", args);
    return 0;
}
