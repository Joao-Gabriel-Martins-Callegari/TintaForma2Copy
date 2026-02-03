var _player = place_meeting(x,y,obj_plr)


if(_player){
    if(!instance_exists(caixa_dialogo)){
        caixa_dialogo = instance_create_layer(x,y-40,"dialogo",obj_caixa_dialogo)
        caixa_dialogo.image_alpha = 0.8
        caixa_dialogo.image_xscale = .1
        caixa_dialogo.texto = meu_texto
        //caixa_dialogo.image_yscale = .1
    }
}else {
	if(instance_exists(caixa_dialogo)){
        caixa_dialogo.destruir = true
    }
}