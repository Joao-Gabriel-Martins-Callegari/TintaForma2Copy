estado = estado_inicial
timer = duracao

timer_estado = function ( _estado="seta"){
    timer--
    if(timer<=0){
        estado = _estado
        timer = duracao
    }
}

maquina_estado = function (){
    switch (estado) {
    	case "seta":{
            mask_index = sprite_index
            image_speed=0
            image_index=0
            timer_estado("trans_xis")
        }
        break;
    
        case "trans_xis":{
            image_speed=1
            if(image_index>=8){
                estado = "xis"
            }
        }
        break
    
        case "xis":{
            mask_index = spr_colisao_dado
            image_index=8
            image_speed=0
            timer_estado("trans_seta")
        }
        break
    
        case "trans_seta":{
            image_speed=1
            if(floor(image_index) == 0){
                estado = "seta"
            }
        }
        break
    }
}