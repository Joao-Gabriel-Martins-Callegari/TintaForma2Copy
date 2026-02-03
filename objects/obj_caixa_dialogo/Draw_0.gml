draw_self()


if(!desenhar_texto) exit

/*
draw_set_font(fnt_dialogo)
draw_set_valign(0)
draw_set_halign(0)


draw_text_ext_transformed(_x,_y,texto,60,_larg,.1,.1,0)

draw_set_valign(-1)
draw_set_halign(-1)
draw_set_font(-1)

*/

var _marg = 2
var _x = x - sprite_width/2 + _marg
var _y = y - sprite_height/2 + _marg
var _larg = sprite_width * 10 - (_marg * 20)



var _txt = scribble(texto).starting_format("fnt_dialogo",c_white)
_txt = _txt.scale(.1)
_txt = _txt.wrap(sprite_width - _marg * 2)


_txt.draw(_x,_y,typist)