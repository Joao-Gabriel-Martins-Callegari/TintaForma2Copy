
//Variavel responsavel por fazer a luz da tocha dar umas "Tremidinhas"
var _esq = random_range(0,0.02)
gpu_set_blendmode(bm_add)
draw_sprite_ext(spr_efeito_brilho, 0, x, y, .3 + _esq, .3 + _esq, 0, c_orange, .2)
gpu_set_blendmode(bm_normal)