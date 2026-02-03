texto = "Teste"
destruir = false
desenhar_texto = false

typist = scribble_typist()
typist.in(.4,1)


scribble_anim_wave(1,.5,.1)
scribble_anim_pulse(.5,.1)
scribble_anim_wheel(1,.5,.1)

iniciando = function (){
    image_xscale = lerp(image_xscale,2.5,.1)
    //image_yscale = lerp(image_yscale,1,.1)
    y = lerp(y,ystart-10,.1)
    
    //Checando se o y chegou proximo o suficiente da posição final dele
    if(y <= ystart - 9.5){
        desenhar_texto = true
    }
}

finalizando = function (){
    if(destruir){
        desenhar_texto = false
        image_xscale = lerp(image_xscale,0,.1)
        image_yscale = lerp(image_yscale,0,.1)
        image_alpha -= .05
        y = lerp(y,y + 30 ,.1)
        
        if(image_alpha <= 0) instance_destroy()
    }
}