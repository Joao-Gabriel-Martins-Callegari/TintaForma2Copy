alvo = noone

movendo = function (){
    
    if(!alvo) return
    
    if(alvo){
        x = alvo.x
        y = alvo.y - 38
    }
}


//Explosão de particulas

//Criei um script para esse codigo de explosão

//explosao = function (_qtd =1, _spd =[1,2], _dir=0){
    //repeat (_qtd) {
    	//var _part = instance_create_layer(x,y, "Enfeites", obj_part_powerUp)
        //_part.speed = random_range(_spd[0],_spd[1])
        //_part.direction = random(_dir)
        //_part.alvo = alvo
    //}
//}