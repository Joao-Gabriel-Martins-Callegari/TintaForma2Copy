if(instance_exists(alvo) and alvo){
    image_alpha -= .02
    if(image_alpha <= 0) instance_destroy()
}