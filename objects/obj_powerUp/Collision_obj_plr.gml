if(alvo == noone){
    other.pega_powerUp()
    alvo = other.id
    other.powerUp = true
    movendo()
    explosao(30,[3,4],359,alvo)
}