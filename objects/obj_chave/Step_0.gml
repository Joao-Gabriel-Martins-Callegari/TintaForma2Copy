var _player = instance_place(x,y,obj_plr)

if(_player){
    particula_chave(20,[4,6],359)
    instance_destroy()
    _player.pega_chaves()
}