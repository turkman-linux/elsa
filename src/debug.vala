namespace elsa {
    #if DEBUG
    public void debug(string msg){
        stderr.printf("\033[34;1m[DEBUG]:\033[;0m %s\n",msg);
    }
    #else
    public void debug(string msg){
        return;
    }
    #endif

}