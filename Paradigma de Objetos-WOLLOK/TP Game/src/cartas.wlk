import jugador.*
class Cartas {
    var valor
    var palo
    var property position = game.at(50, 50) 


    method initialize(valorInicial, paloInicial) {
        valor = valorInicial
        palo = paloInicial
    }

    method valorCarta() {
        return valor
    }

    method paloCarta() {
        return palo
    }

    var imagen= palo + valor + ".png"
    method image() = imagen

    method seleccion() {
        if (imagen == palo + valor + ".png") {
        imagen = palo + valor + "s"+".png"
        } else {
        imagen = palo + valor + ".png"
    }
    }
    
}
