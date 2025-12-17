
object pepita {
    var position= game.at(1, 8)

    method position()=position
    method position(newPos) {
        self.volar(1)
        position=newPos  
    }

    var image = "mini.png"

    method image()=image
    method image(newIm){
        image=newIm
    }

	var energia = 100

    method estaCansada() {
    return energia <=20
    }

    method ganar () = "Gane"
    
    method volar(metros) {
        energia = energia - metros *10
    }

    method comer(comida) {
    energia += comida.energia()
    }

    method estaViva() {
        return energia >= 0
    }

}

object alpiste {
    method energia() = 20


    //Posiciones aleatorias
    method position()=position
    const position = game.at(0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.width()).truncate(0))
    
    method image()= "alpiste2.png"

}

object manzana {
    method energia() =20

    method position ()= game.at(7, 7)
    method image()= "manzana2.png"
}

object nido{
    method image() ="nido.png"
    method position ()= game.at(1,1)

}