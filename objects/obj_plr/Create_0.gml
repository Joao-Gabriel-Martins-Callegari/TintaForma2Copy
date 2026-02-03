cria_efeito_squash()
inicia_efeito_brilho()


vel = 2
velh = 0
left  = false 
right = false
jump  = false
velv = 0
max_velv = 5
grav  = .3
chao = false
tinta = false
powerUp = false
dir = 1
chaves = 0
shift_spd = 4

coyote_timer = game_get_speed(gamespeed_fps) * .1
coyote_timer_atual = coyote_timer


pulo_timer = game_get_speed(gamespeed_fps) * .1
pulo_timer_atual = 0


corner_pixels = 8


//qtd_pulos = 0
//qtd_pulos_atual = qtd_pulos


lista_sprites = [spr_correr_idle,spr_plr_idle]
indice_sprite = 0

var _layer = layer_tilemap_get_id("level")
colisoes = [obj_parede, _layer, obj_parede_one_way]

estado = noone


inputs = function (){
    left = keyboard_check(ord("A"))
    right = keyboard_check(ord("D"))
    jump = keyboard_check_pressed(vk_space)
    tinta = keyboard_check_pressed(ord("S"))
    shift = keyboard_check(vk_shift)
}


movimento = function (){
    
    mask_index = spr_plr_idle
    
    
    //Aplicando os inputs na velh
    velh = (right - left) * vel
    
    if(!chao){
        velv += grav
    }else {
    	velv = 0
        y = round(y)
        
        if(jump and chao){
            efeito_squash(.5,1.8)
            velv -= max_velv
            instance_create_depth(x,y,depth - 1, obj_part_pulo)
            estado = estado_pulo
        }
        
        if(jump or pulo_timer_atual > 0){
            velv = -max_velv
            pulo_timer_atual = 0
        }
        
    }
    
    //Usando o move and collide
    move_and_collide(velh,0,colisoes,4)
    move_and_collide(0,velv,colisoes,12)
    chao = place_meeting(x,y+1,colisoes)
    
}



ativar_correr = function (){
    if(shift){
        vel = shift_spd
    }else {
    	vel = 2 
    }
}


//Criando meu metodo de coyote jump
coyote_jumpe = function (){
    if(!chao){
        coyote_timer_atual--
    }else {
    	coyote_timer_atual = coyote_timer
    }
}


buffer_pulo = function (){
    if(!chao){
        
        if(jump) pulo_timer_atual = pulo_timer
            
        pulo_timer_atual--
        
    }
}


//Se eu estou DENTRO do one way, eu remove ele da colisao
removendo_colisao_one_way = function (){
    var _one_way = instance_place(x,y,obj_parede_one_way)
    if(_one_way and array_contains(colisoes,obj_parede_one_way)){
        var _ind = array_get_index(colisoes,obj_parede_one_way)
        array_delete(colisoes,_ind, 1)
    }
}


muda_sprite = function (_sprite = spr_parede){
    if(sprite_index != _sprite){
        sprite_index = _sprite
        image_index = 0
    }
}


acabou_animacao = function (){
    var _spd = sprite_get_speed(sprite_index) / FPS
    if(image_index + _spd >= image_number){
        return true
    }
}

tintas = function (){
    var _tinta = layer_tilemap_get_id("tinta")
    var _chao_tinta = place_meeting(x,y+1,_tinta)
    if(tinta and powerUp and _chao_tinta) {
      troca_estado(estado_entrar_tinta, [spr_plr_toEnter_ink])
      instance_create_depth(x,y,depth - 1, obj_tinta_entrar)
    }
}


pega_powerUp = function (){
    if(place_meeting(x,y,obj_powerUp)){
        estado = estado_animacao_inicio
    }
}


//Metodo para fazer a transição de sprites
transicao_sprites = function (){
    //muda_sprite(spr_plr_idle)
    muda_sprite(lista_sprites[indice_sprite])
    
    var _qtd = array_length(lista_sprites) -1
    
    if(acabou_animacao() and indice_sprite < _qtd){
        indice_sprite++
    }
    
}

troca_estado = function (_estado = estado_parado, _lista = lista_sprites[spr_plr_idle]){
    estado = _estado
    indice_sprite = 0
    lista_sprites = _lista
}


estado_parado = function (){
    movimento()
    
    transicao_sprites()
    
    
    if(right xor left){
        troca_estado(estado_movendo,[spr_plr_idle_correr,spr_plr_run])
    } 
        
    if(chao and jump){
        troca_estado(estado_pulo,[spr_plr_prepara_pulo,spr_plr_jump_up])
    }
    
        
    if(!chao) estado = estado_pulo
        
    tintas()
    
}

estado_movendo = function (){
    
    movimento()
    
    transicao_sprites()
    
    if(velh == 0 and chao){
        troca_estado(estado_parado, [spr_correr_idle,spr_plr_idle])
    } 
        
    if(chao and jump or !chao) troca_estado(estado_pulo,[spr_plr_prepara_pulo, spr_plr_jump_up])
        
    //if(!chao) estado = estado_pulo
    
    tintas()
    
}


ajusta_escala = function (){
    //if(velh > 0) image_xscale = 1
    //if(velh < 0) image_xscale = -1
    
    if(velh != 0) dir = sign(velh)
}




estado_pulo = function (){
    
    static _inicia_pulo  = true
    //Acabei de entrar nesse estado
    if(_inicia_pulo){
        _inicia_pulo = false
    }
    
    if(coyote_timer_atual > 0 and jump){
        velv = -max_velv
        
        coyote_timer_atual = 0
        
        efeito_squash(.5,1.8)
        instance_create_depth(x,y,depth - 1, obj_part_pulo)
    }

    
    
    movimento()
    
    transicao_sprites()
    
    //Se eu bater na minha parede subindo eu zero meu velv
    var _layer = layer_tilemap_get_id("level")
    var _colisoes = [obj_parede,_layer]
    var _cond = false
    if(place_meeting(x,y+sign(velv),_colisoes)){
        
        _cond = true
        
        if(velv < 0){
            
            if(velh >= 0){
                for (var i = 0; i < corner_pixels; i++) { 
                    var _livre = !place_meeting(x+i, y+velv,_colisoes)
                    if(_livre){
                        //Se tenho espaço livre eu vou mover o meu player para aquela posição
                        x += i
                        _cond = false
                        break;
                   }
                
                }
            }
            
            if(velh <= 0){
                for (var i = 0; i < corner_pixels; i++) {
                	var _livre = !place_meeting(x-i,y+velv,_colisoes)
                    if(_livre){
                        x -= i
                        _cond = false
                        break
                    }
                }
            }
        }
        
        if(_cond) velv = 0
        
    }
    
    
    var _parede = array_contains(colisoes,obj_parede_one_way)
    if(velv < 0){
        transicao_sprites()
        if(_parede){
            var _index = array_get_index(colisoes, obj_parede_one_way)
            array_delete(colisoes,_index,1)
        }
        
        if(keyboard_check_released(vk_space)){
            velv *= 0.5
        }
    }else if(velv > 0) {
        lista_sprites = [spr_plr_queda, spr_plr_jump_down]
        transicao_sprites()
        if(!place_meeting(x,y,obj_parede_one_way)){
            if(!_parede){
                array_push(colisoes, obj_parede_one_way)    
            }
        }
    }
    
    
    //if(jump and qtd_pulos_atual > 0){
        //
        //lista_sprites = [spr_plr_prepara_pulo,spr_plr_jump_up]
        //transicao_sprites()
        //
        //velv -= max_velv
        //qtd_pulos_atual--
    //}
    //
    
    if(chao){
        _inicia_pulo = true
        
        efeito_squash(1.8,.5)
        troca_estado(estado_parado, [spr_plr_pousar, spr_plr_idle])
        instance_create_depth(x,y,depth-1,obj_part_pouso)
    }
    
    //Limitando minha velv
    var _queda = 8
    velv = clamp(velv, -_queda, _queda)
}

estado_animacao_inicio = function (){
    muda_sprite(spr_plr_powerUp_1)
    if(acabou_animacao()) estado = estado_animacao_meio
    
}

estado_animacao_meio = function (){
    muda_sprite(spr_plr_powerUp_2)
    
    //Se o numero de particulas for menor ou igual a zero, eu mudo de estado
    if(instance_number(obj_part_powerUp) <= 0) estado = estado_animacao_fim
    
}

estado_animacao_fim = function (){
    muda_sprite(spr_plr_powerUp_3)
    if(acabou_animacao()) troca_estado(estado_parado,[spr_plr_idle])
}

//Este estado vai entrar no loop da tinta
estado_entrar_tinta = function (){
    velh = 0
    transicao_sprites()
    if(acabou_animacao()){
        troca_estado(estado_loop_tinta, [spr_plr_tinta_inicio, spr_tinta_loop])
    }
}


estado_loop_tinta = function (){
    var _teto = place_meeting(x,y-10,colisoes)
    
    transicao_sprites()
    
    movimento_tinta()
    
    if(jump and !_teto){
        troca_estado(estado_sair_tinta, [spr_plr_tinta_fim, spr_plr_leave_ink])
        instance_create_depth(x,y,depth - 1, obj_tinta_sair)
    } 

}

estado_sair_tinta = function (){
    velh = 0
    
    mask_index = spr_plr_idle
    
    var _qtd = array_length(lista_sprites) -1
    if(acabou_animacao() and indice_sprite >= _qtd) {
        troca_estado(estado_parado, [spr_plr_idle])
    }
    transicao_sprites()
}



movimento_tinta = function (){
    mask_index = spr_tinta_loop
    //Pegando a direção que o player esta indo
    var _dir = right - left
    
    //Verificando se minha direção é diferente de 0
    if(_dir != 0){
        //Se for, eu verifico se eu tenho chão para poder pisar
        var _chao_tinta = layer_tilemap_get_id("tinta")
        var _chao = place_meeting(x + _dir * sprite_width, y + 1, _chao_tinta)
        
        //Se eu tenho chão
        if(_chao){
            //Eu me movo na direção que eu estou indo
            velh = _dir * vel
        }else { //Se não
            //Eu zero meu velh
        	velh = 0
        }
    }else { //Se não for diferente de 0
        //Então eu não ando
    	velh = 0
    }
    
    //Zerando minha velocidade vertical
    velv = 0
    
    // Atualiza a direção do sprite apenas se houve movimento
    if(velh != 0) dir = sign(velh)
    
    //Chamando o move_and_collide
    move_and_collide(velh,0,colisoes,4)
    
}


pega_chaves = function (){
    chaves++
}

abre_porta = function (){
    //Checando com QUAL porta eu estou colidindo
    var _porta = instance_place(x+velh,y,obj_porta)
    
    if(_porta and chaves > 0 and _porta.estado == "fechado"){
        _porta.estado = "abrindo"
        chaves--
    }
}



#region debug

view_player = noone

debug = function(){
    

    show_debug_overlay(1)
    
    view_player = dbg_view("View Player", 1, 100,100,300,400)

    var _ref_velv = ref_create(self,"velv")
    dbg_watch(_ref_velv,"velv")
    
    var _ref_max_velv = ref_create(self,"max_velv")
    dbg_slider(_ref_max_velv,0,10, "Max velv", .1)
    
    var _ref_grav = ref_create(self,"grav")
    dbg_slider(_ref_grav,0,1, "Gravity", .1)
}


ativa_debug = function (){
    
    //Se o jogo não esta no modo debug, ele não faz nada do debug
    if(!DEBUG_MODE) return
    
    if(keyboard_check_pressed(vk_tab)){
        global.debug = !global.debug
        
        if(global.debug){
            debug()
        }else {
            show_debug_overlay(0)
        	//Se minha view existe e eu não estou usand ela, eu deleto ela
            if(dbg_view_exists(view_player)){
                dbg_view_delete(view_player)
            }
        }
    }
}


#endregion


estado = estado_parado