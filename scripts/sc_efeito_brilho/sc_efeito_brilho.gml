//Iniciar efeito brilho

function inicia_efeito_brilho (){
    xscale = 1
    yscale = 1
    dir = 0
    alpha = 0
    cor = c_white
}


function aplica_efeito_brilho(_alpha = 1, _cor = c_white){
    alpha = _alpha
    cor = _cor
}


function reseta_efeito_brilho(_qtd = .1){
    alpha = lerp(alpha,0,_qtd)
}


function desenha_efeito_brilho(){
    if(alpha > 0){
        shader_set(sh_mudaCor)
        draw_sprite_ext(sprite_index,image_index,x,y,xscale * dir,yscale,image_angle,cor,alpha)
        shader_reset()
    }
}