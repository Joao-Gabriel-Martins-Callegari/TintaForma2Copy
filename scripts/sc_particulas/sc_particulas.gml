//Explosão de particulas
function explosao(_qtd =1, _spd =[1,2], _dir=0, _alvo = noone){
    repeat (_qtd) {
    	var _part = instance_create_layer(x,y, "Enfeites", obj_part_powerUp)
        _part.speed = random_range(_spd[0],_spd[1])
        _part.direction = random(_dir)
        _part.alvo = _alvo
    }
}


function particula_chave(_qtd=1,_spd=[1,2],_dir=0){
    repeat (_qtd) {
    	var _particulas = instance_create_layer(x,y,"Enfeites",obj_part_chave)
        _particulas.speed = random_range(_spd[0],_spd[1])
        _particulas.speed *= -.1
        _particulas.direction = random(_dir)
    }
}