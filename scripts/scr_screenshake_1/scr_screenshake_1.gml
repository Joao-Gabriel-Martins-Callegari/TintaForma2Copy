function screenshake (_tremer = 1){
    if(instance_exists(oScreenshake)){
        with (oScreenshake) {
            if(_tremer > tremer){
                tremer = _tremer
            }
        }
    }
}