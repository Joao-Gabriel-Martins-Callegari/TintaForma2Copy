inputs()
ativa_debug()
estado()
ajusta_escala()
retorna_squash()
abre_porta()

removendo_colisao_one_way()


coyote_jumpe()
buffer_pulo()
ativar_correr()


//Deixando o jogo em tela cheia quando eu apertar o F11
//Ou tirar de tela cheia
if(keyboard_check_pressed(vk_f11)){
    var _full = window_get_fullscreen()
    window_set_fullscreen(!_full)
}

if(keyboard_check_pressed(ord("R"))){
    cria_transicao_inicia(room)
}


reseta_efeito_brilho(.1)
