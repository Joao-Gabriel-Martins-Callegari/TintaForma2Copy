//Eu so vou rodar meu codigo se eu tenho um alvo

if(!alvo) exit
    
image_alpha = speed/5
    

image_xscale = lerp(image_xscale,speed * 5, 0.1)
image_yscale = 0.5
image_angle = direction


if(!voltar){
    speed -= 0.1
    
    //Checando se eu ja zerei a minha velocidade 
    if(speed <= 0){
        voltar = true
        var _dir = point_direction(x,y,alvo.x,alvo.y - 12)
        direction = _dir
    }
}else {
	speed += 0.2

    var _player = instance_place(x,y, obj_plr)
    if(_player){
        with (_player) {
            var _cor = choose(c_orange,c_purple,c_blue)
            var _alpha = random_range(0.3,1)
            
            aplica_efeito_brilho(_alpha,_cor)
        	efeito_squash(1.1,1.5)
        }
        screenshake(7)
        instance_destroy()
    }
    
    
}
//Se eu ja estou voltando, eu não preciso diminuir a minha velocidade
//Mas eu preciso ir na direção do player
//E agora eu preciso ganhar velocidade
 
//Só vou rodar isso DEPOIS de ter perdido minha velocidade