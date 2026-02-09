cria_efeito_squash()
inicia_efeito_brilho()

//Variavel de velocidade
vel = 2
//Variavel da velocidade Horizontal
velh = 0
//Variavel da velocidade Vertical
velv = 0
//Variavel dos inputs do teclado
left  = false 
right = false
jump  = false
//Variavel da Velocidade maxima Vertical
max_velv = 5
//Variavel de gravidade
grav  = .3
//Variavel que controla se estou no chão ou não
chao = false
//Variavel que controla se estou na tinta ou não
tinta = false
//Variavel que controla se estou com powerUp ou não
powerUp = false
//Variavel que controla a minha direção
dir = 1
//Variavel que recebe quantas chaves o player possui
chaves = 0
//Variavel da velocidade do player quando ele correr
shift_spd = 4

//Variaveis para controlar o Coyote Timer
coyote_timer = game_get_speed(gamespeed_fps) * .1
coyote_timer_atual = coyote_timer

//Variaveis para controlar o tempo de pulo 
pulo_timer = game_get_speed(gamespeed_fps) * .1
pulo_timer_atual = 0

//Essa Variavel verificar se eu estou a X pixel de distancia do fim da minha "Parede"
//Se eu estiver ele move o player X pixels como se ele escorregasse no teto quando esta 
//Proximo a uma "Quina"
corner_pixels = 8


//qtd_pulos = 0
//qtd_pulos_atual = qtd_pulos

//Lista das sprites do player
lista_sprites = [spr_correr_idle,spr_plr_idle]

//Variavel responsavel pelo indice da lista de sprites do player
indice_sprite = 0

//Variavel que pega colisão com o tileset do jogo
var _layer = layer_tilemap_get_id("level")
//Lista de colisão
colisoes = [obj_parede, _layer, obj_parede_one_way]

//Variavel que controla o estado atual do player
estado = noone

//Metodo responsavel por pegar os inputs do teclado do jogador
inputs = function (){
    left = keyboard_check(ord("A"))
    right = keyboard_check(ord("D"))
    jump = keyboard_check_pressed(vk_space)
    tinta = keyboard_check_pressed(ord("S"))
    shift = keyboard_check(vk_shift)
}

//Metodo de movimento do player
movimento = function (){
    
    //Ajustando a mascara de colisão do player
    //Para a sprite do player parado
    mask_index = spr_plr_idle
    
    
    //Aplicando os inputs na velh
    velh = (right - left) * vel
    
    //Checando se eu não estou colidindo com o chão
    if(!chao){
        //Se não estou colidindo, eu aplico gravidade ao player
        velv += grav
    }else { //Caso contrario, se estou colidindo com o chão
        //Eu zero minha velocidade vertical
    	velv = 0
        //Arredonda a posição Y para evitar que o player fique "preso" em pixels quebrados
        y = round(y)
        
        //Checando se eu apertei o botão de pulo E se estou tocando no chão
        if(jump and chao){
            //Se sim, eu uso a função de efeito_squash para esticar o player
            efeito_squash(.5,1.8)
            //Faço o meu player subir
            velv -= max_velv
            //Crio a particula de pulo 
            instance_create_depth(x,y,depth - 1, obj_part_pulo)
            //Mudo o estado do player para o estado_pulo
            estado = estado_pulo
        }
        
        //Checando se eu apertei o botão de pulo OU se o pulo_timer_atual é maior que 0
        if(jump or pulo_timer_atual > 0){
            //Se for, eu faço o player subir
            velv = -max_velv
            //Falo que o meu pulo_timer_atual é 0
            pulo_timer_atual = 0
        }
        
    }
    
    // Move o personagem horizontalmente checando colisões (máximo de 4 pixels de ajuste)
    move_and_collide(velh,0,colisoes,4)
    // Move o personagem verticalmente checando colisões (máximo de 12 pixels de ajuste)
    move_and_collide(0,velv,colisoes,12)
    // Atualiza a variável 'chao' verificando se há uma colisão 1 pixel abaixo da posição atual
    chao = place_meeting(x,y+1,colisoes)
    
}


//Metodo de correr do player
ativar_correr = function (){
    //Se eu apertei a tecla SHIFT
    if(shift){
        //Minha velocidade muda para a velocidade do shift_spd
        vel = shift_spd
    }else {
        //Se eu não estou mais apertando o SHIFT
        //Eu reseto a minha velocidade para o valor padrão
    	vel = 2 
    }
}


//Criando meu metodo de coyote jump
coyote_jumpe = function (){
    //Checando se eu NÃO estou no chão
    if(!chao){
        //Diminuindo o meu timer
        coyote_timer_atual--
    }else {
        //Caso contrario eu reseto o meu coyote timer 
    	coyote_timer_atual = coyote_timer
    }
}

//Metodo de buffer do pulo
buffer_pulo = function (){
    //Se eu não estou no chão
    if(!chao){
        //Checando se eu eu apertei o botão de pulo
        if(jump) pulo_timer_atual = pulo_timer // Resetando meu timer de pulo
            
        //Diminuindo o meu timer de pulo
        pulo_timer_atual--
    }
}


//Se eu estou DENTRO do one way, eu remove ele da colisao
removendo_colisao_one_way = function (){
    //Variavel temporaria responsavel por pegar o ID da minha plataforma one way
    var _one_way = instance_place(x,y,obj_parede_one_way)
    //Checando se eu colidi com a parede oneWay E se minha colisão com o obj_parede_one_way
    //Esta na minha lista de colisoes
    if(_one_way and array_contains(colisoes,obj_parede_one_way)){
        //Variavel temporaria por pegar o indice da minha parede_one_way dentro do meu array
        var _ind = array_get_index(colisoes,obj_parede_one_way)
        //Deletando a minha colisão com a parede one_way depois que eu achar o indice dela
        array_delete(colisoes,_ind, 1)
    }
}


//Metodo de mudar de sprite
muda_sprite = function (_sprite = spr_parede){ //Passando uma sprite como parametro
    //Verificando se a minha sprite atual é diferente
    //Da sprite que eu passei como parametro
    if(sprite_index != _sprite){
        //Se sim, eu mudo minha sprite
        sprite_index = _sprite
        //Faço minha sprite começar do inicio
        image_index = 0
    }
}


//Metodo responsavel por checar se minha animação acabou
acabou_animacao = function (){
    //Variavel temporaria responsavel por pegar a velocidade da minha sprite
    //E dividir ela pela variavel de macro do FPS 
    var _spd = sprite_get_speed(sprite_index) / FPS
    //Checando se minha image_index + a minha variavel _spd é maior ou igual 
    //Ao numero de imagens da minha sprite
    if(image_index + _spd >= image_number){
        //Se sim, eu retorno true
        return true
    }
}

//Metodo de entrar na tinta
tintas = function (){
    //Variavel temporaria responsavel por pegar colisão com o tileset de tinta
    var _tinta = layer_tilemap_get_id("tinta")
    //Variavel temporaria que checa se eu estou colidindo no chão de tinta
    var _chao_tinta = place_meeting(x,y+1,_tinta)
    //Se eu apertei a tecla para entrar na tinta
    //E se eu tenho o powerUp de tinta
    //E estou colidindo com o chão de tinta
    if(tinta and powerUp and _chao_tinta) {
        //Eu chamo a função que troca o estado com player
        //Com uma "pequena animação dele entranto na tinta"
      troca_estado(estado_entrar_tinta, [spr_plr_toEnter_ink])
        //Crio as particulas de tinta
      instance_create_depth(x,y,depth - 1, obj_tinta_entrar)
    }
}

//Metodo responsavel por pegar o powerUp
pega_powerUp = function (){
    //Se eu estou colidindo com o powerUp
    if(place_meeting(x,y,obj_powerUp)){
        //Eu mudo meu estado para o estado_animacao_inicio
        estado = estado_animacao_inicio
    }
}


//Metodo para fazer a transição de sprites
transicao_sprites = function (){
    //muda_sprite(spr_plr_idle)
    //Chamando o metodo de mudar_sprite e passando a lista de sprite
    //Que eu quero
    muda_sprite(lista_sprites[indice_sprite])
    //Variavel temporaria responsavel por pegar o tamanho da minha lista de sprites
    var _qtd = array_length(lista_sprites) -1
    
    //Checando se minha animação acabou E se o indice da minha lista de sprite
    //E menor do que o tamanho da minha lista
    if(acabou_animacao() and indice_sprite < _qtd){
        //Se for true, eu aumento o valor do meu indice_sprite em +1
        indice_sprite++
    }
}

//Metodo para mudar de estado recebendo os seguintes parametros
//Qual estado ele deve mudar
//Qual lista de sprites eu quero que ele use
troca_estado = function (_estado = estado_parado, _lista = lista_sprites[spr_plr_idle]){
    //Mudando meu estado para o valor do parametro
    estado = _estado
    //Reseto o indice_sprite para ele começar
    //A minha lista de sprites do inicio
    indice_sprite = 0
    //Mudando minha lista de sprite para o valor do parametro
    lista_sprites = _lista
}

//Estado de parado
estado_parado = function (){
    //Chamando meu metodo de movimento 
    movimento()
    //Chamando minha função de transição de sprites
    transicao_sprites()
    
    //Se eu me movi para a direita ou para esquerda 
    if(right xor left){
        //Eu chamo minha função de troca estado para ir para o estado_movendo
        troca_estado(estado_movendo,[spr_plr_idle_correr,spr_plr_run])
    } 
        
    //Checando se eu estou no chão E se eu apertei o botão de pulo
    if(chao and jump){
        //Mudando o estado do player para o estado de pulo
        troca_estado(estado_pulo,[spr_plr_prepara_pulo,spr_plr_jump_up])
    }
    
        
    //Se eu não estou colidindo no chão, eu mudo para o estado pulo tbm
    if(!chao) estado = estado_pulo
        
    //Chamo a função de poder entrar na tinta
    tintas()
    
}

//Estado de movendo
estado_movendo = function (){
    
    //Chamando a função de movimento
    movimento()
    
    //Chamando a função de transição de sprite
    transicao_sprites()
    
    //Se minha velocidade Horizontal for igual a 0 E estou no chão
    if(velh == 0 and chao){
        //Mudo para o estado de parado
        troca_estado(estado_parado, [spr_correr_idle,spr_plr_idle])
    } 
        
    //Se eu estou  no chão E eu pulei OU não estou no chão (estou caindo)
    //Eu mudo para o estado de pulo
    if(chao and jump or !chao) troca_estado(estado_pulo,[spr_plr_prepara_pulo, spr_plr_jump_up])
        
    //if(!chao) estado = estado_pulo
    
    //Chamando o metodo de entrar na tinta
    tintas()
    
}

//Metodo responsavel por ajustar escala
ajusta_escala = function (){
    //if(velh > 0) image_xscale = 1
    //if(velh < 0) image_xscale = -1
    
    //Se minha velocidade Horizontal for diferente de 0
    //Eu mudo a minha direção usando a função sign
    //Fazendo com que eu olho para esquerda e direita
    if(velh != 0) dir = sign(velh)
}

//Estado de pulo
estado_pulo = function (){
    
    //Variavel estatica responsavel por avisar 
    //Se eu dei meu "PRIMEIRO" pulo
    static _inicia_pulo  = true
    //Acabei de entrar nesse estado
    if(_inicia_pulo){
        //Eu aviso que eu ja dei meu primeiro pulo
        _inicia_pulo = false
    }
    
    //Checando se meu coyote_timer é maior que 0
    //E se eu apertei o botão de pulo
    if(coyote_timer_atual > 0 and jump){
        //Se sim, eu faço meu player subir
        velv = -max_velv
        //Faço meu timer ser igual a 0
        coyote_timer_atual = 0
        //Aplico o efeito de mola no pplayer
        efeito_squash(.5,1.8)
        //Crio a particula de pulo
        instance_create_depth(x,y,depth - 1, obj_part_pulo)
    }

    //Chamo meu metodo de movimento
    movimento()
    
    //Chamo meu metodo de transição de sprites
    transicao_sprites()
    
    //Se eu bater na minha parede subindo eu zero meu velv
    //Variavel que pega colisão com o tileset do level
    var _layer = layer_tilemap_get_id("level")
    //Variavel temporaria que pega somente as colisões
    //Necessarias dentro do meu estado de pulo
    var _colisoes = [obj_parede,_layer]
    //Variavel responsavel por checar se minha condição é true ou false
    var _cond = false
    //Se houver uma colisão na direção em que estou me movendo verticalmente
    //(Subindo ou descendo)
    if(place_meeting(x,y+sign(velv),_colisoes)){
        
        //Ativo a condição de que houve colisão
        _cond = true
        
        //Se meu velv for menor que
        //Apenas se estiver subindo (pulando)
        if(velv < 0){
            //Eu checo se meu velh (Velocidade Horizontal) é maior ou igual a 0
            //Checando a quina da direita
            if(velh >= 0){
                for (var i = 0; i < corner_pixels; i++) { 
                    //Se eu me mover 'i' pixels para o lado, o caminho acima fica livre?
                    var _livre = !place_meeting(x+i, y+velv,_colisoes)
                    //Se sim, eu "Teleporto" o player para o lado livre
                    if(_livre){
                        //Se tenho espaço livre eu vou mover o meu player para aquela posição
                        x += i
                        //Cancela a pareda da velocidade vertical
                        _cond = false
                        break;
                   }
                
                }
            }
            
            //(O mesmo se repete para o lado esquerdo)
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
        
        //Se minha condição é true
        if(_cond) velv = 0 //Eu zero minha velocidade vertical
        
    }
    
    //Variavel responsavel por chegar se minha colisão com a parede_one_way
    //Existe no meu array de colisões
    var _parede = array_contains(colisoes,obj_parede_one_way)
    //Se eu estou subindo
    if(velv < 0){
        //Chamo meu metodo de transição de sprites
        transicao_sprites()
        //Se existe colisão no meu array
        if(_parede){
            //Eu crio uma variavel responsavel por pegar o "index" (Indice)
            //Da minha colisão dentro do meu array para eu saber 
            //"Onde ela esta".
            var _index = array_get_index(colisoes, obj_parede_one_way)
            //Removendo a colisão da minha parede com base na posição 
            //Em que ela se encontra (Indice)
            array_delete(colisoes,_index,1)
        }
        //Se eu soltei a tecla de espaço
        if(keyboard_check_released(vk_space)){
            //Eu multiplico minha velv por um valor menor que 0
            //Fazendo com que eu corte o impulso de subida pela metade
            velv *= 0.5
        }
    }else if(velv > 0) { //Caso contrario se minha velv é maior que 0 (estou caindo)
        //Defino quais sprites serão usadas na minha lista_sprites
        lista_sprites = [spr_plr_queda, spr_plr_jump_down]
        //Chamo o metodo de transição de sprites
        transicao_sprites()
        //Se eu não estou colidindo com a parede one way
        if(!place_meeting(x,y,obj_parede_one_way)){
            //Se não existe ainda a colisão da minha parede onw way 
            //Dentro do meu array de colisões
            if(!_parede){
                //Eu adiciono a colisão dentro da minha lista
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
    
    //Se estou colidindo com o chão
    if(chao){
        //Eu aviso que meu player pode dar o "Primeiro" pulo
        _inicia_pulo = true
        //Aplico o efeito de mola
        efeito_squash(1.8,.5)
        //Chamo o metodo que troca de estado para o estado de parado
        //Pois se eu colidi com o chão, eu quero que meu player
        //Fique parado, e passo a lisat de sprites que ele vai usar
        //Na animação de "Caindo"
        troca_estado(estado_parado, [spr_plr_pousar, spr_plr_idle])
        //Criando a particula de pouso
        instance_create_depth(x,y,depth-1,obj_part_pouso)
    }
    
    //Limitando minha velv
    var _queda = 8
    velv = clamp(velv, -_queda, _queda)
}

//Estado de inicio da minha animação do powerUp
estado_animacao_inicio = function (){
    //Chamo meu metodo de muda sprite
    //E escolho a sprite inicial do powerUp
    muda_sprite(spr_plr_powerUp_1)
    //Checo se a minha animação inicial acabou
    //Se sim, eu mudo para o estado do meio da animação
    if(acabou_animacao()) estado = estado_animacao_meio
}


//Estado do meio da animação do powerUp
estado_animacao_meio = function (){
    //Mudo para a sprite do meio da animação
    muda_sprite(spr_plr_powerUp_2)
    
    //Se o numero de particulas for menor ou igual a zero, eu mudo de estado
    //Para o estado final da animação do powerUp
    if(instance_number(obj_part_powerUp) <= 0) estado = estado_animacao_fim
}

//Estado final da animação
estado_animacao_fim = function (){
    //Mudo para a sprite final da animação
    muda_sprite(spr_plr_powerUp_3)
    //Se acabou a animação eu volto para o estado parado
    if(acabou_animacao()) troca_estado(estado_parado,[spr_plr_idle])
}

//Este estado vai entrar no loop da tinta
estado_entrar_tinta = function (){
    //Zero minha veloidade Horizontal
    //Impedindo o player se mover durante a animação
    velh = 0
    //Chamo o metodo de transição de sprites
    transicao_sprites()
    //Checo se a animação do player entrando na tinta acabou
    if(acabou_animacao()){
        //Se sim, eu mudo para o estado de tinta_loop, e passo a lista de sprites
        //Que ele deve percorrer quando o player entra na tinta, antes de ficar 
        //No loop de animação da tinta
        troca_estado(estado_loop_tinta, [spr_plr_tinta_inicio, spr_tinta_loop])
    }
}

//Estado de loop da tinta
estado_loop_tinta = function (){
    //Variavel responsavel por checar se existe colisão com o "Teto"
    //No caso 10 pixels acima dele
    var _teto = place_meeting(x,y-10,colisoes)
    
    //Chamo o metodo de transição de sprite
    transicao_sprites()
    
    //Chamo o metodo de movimento da tinta
    movimento_tinta()
    
    //Se eu apertei o botão de pulo 
    //E não tem Teto para eu colidir
    if(jump and !_teto){
        //Eu mudo meu estado para o estado de sair da tinta
        troca_estado(estado_sair_tinta, [spr_plr_tinta_fim, spr_plr_leave_ink])
        //Crio particulas do player saindo da tinta
        instance_create_depth(x,y,depth - 1, obj_tinta_sair)
    } 
}

//Estado de sair da tinta
estado_sair_tinta = function (){
    //Zero minha velocidade Horizontal
    //Impedindo o player de se mover durante a animação
    velh = 0
    
    //Mudo a mascara de colisão do player
    //Para a mascara de colisão da sprite dele parado
    mask_index = spr_plr_idle
    
    //Variavel temporaria responsavel por pegar o tamanho 
    //Da minha lista de sprites
    var _qtd = array_length(lista_sprites) -1
    //Checando se acabou a animação E se o indice_sprite é maior ou igual
    //Ao tamanho do meu vetor de lista_sprites
    if(acabou_animacao() and indice_sprite >= _qtd) {
        //Se sim, eu mudo o estado do player para o estado de parado
        troca_estado(estado_parado, [spr_plr_idle])
    }
    //Chamo o metodo de transição de sprites
    transicao_sprites()
}


//Metodo de movimento da tinta
movimento_tinta = function (){
    //Mudo a mascara de colisão para a sprite da tinta
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

//Metodo de pegar chaves
pega_chaves = function (){
    //Aumento em +1 o valor da minha variavel de chaves
    chaves++
}

//Metodo de abrir porta
abre_porta = function (){
    //Checando com QUAL porta eu estou colidindo
    var _porta = instance_place(x+velh,y,obj_porta)
    
    //Se estou colidindo com uma porta E minha variavel chaves é maior que 0
    //E se o estado atual da minha porta é igual a 'fechado'
    if(_porta and chaves > 0 and _porta.estado == "fechado"){
        //Se tudo isso for true
        //Eu mudo o estado da porta para 'abrindo'
        _porta.estado = "abrindo"
        //Diminuio a quantidade de chaves que tenho
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