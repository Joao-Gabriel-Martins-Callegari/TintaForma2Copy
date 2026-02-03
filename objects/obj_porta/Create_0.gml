estado = "fechado"


maquina_estados = function (){
    switch (estado) {
    	case "fechado":
        {
            
        }
            
        break;
    
        case "abrindo":
        {
            vspeed = -.3
            var _final = ystart - sprite_height
            screenshake(3)
            
            x = xstart + random_range(1,-1)
            
            if(y < _final) estado = "aberta"
        }
        
        break;
    
        case "aberta":
        {
            vspeed = 0
            x = xstart
        }
            
        break;
    }
}


