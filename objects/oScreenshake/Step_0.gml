if(tremer > 0.1){
    
    var _x = random_range(-tremer, tremer)
    var _y = random_range(-tremer, tremer)
    
    view_set_xport(view_current,_x)
    view_set_yport(view_current,_y)
}

tremer = lerp(tremer, 0, .1)