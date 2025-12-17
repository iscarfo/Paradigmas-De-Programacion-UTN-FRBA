import cartas.*
import jugador.*
object tablero{
    const mazo = []
    const mesa = []
    const jugadores = []

    method mostrarMazo() = mazo
    method mostrarMesa() = mesa
    method limpiarMesa() = mesa.clear()

    method jugadorConTurno() = jugadores.find({j => j.turno() == 1})

    method anadirCartaMesa(carta) = mesa.add(carta)
    
    method saberPuntajeMesa() = mesa.map({carta => carta.valorCarta()}).sum()
    
    method agarrarCarta() {
        if (mazo.isEmpty()) throw new Exception(message="No hay cartas en el mazo")
        const carta = mazo.anyOne()
        mazo.remove(carta)
        return carta

    }

   

    method llenarMazo() {
    const num = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    const palos = ["oro", "copa", "basto", "espada"]
    
    palos.forEach({palo => 
        num.forEach({ncarta => 
            mazo.add(new Cartas(valor = ncarta, palo = palo))})
                })
    }

    method llenarMesa() {
        (1..4).forEach({
            cartas => self.anadirCartaMesa(self.agarrarCarta())
        })
    }

    method repartirJugadores() {
        (1..3).forEach({n => jugadores.forEach({jugador => jugador.anadirCartaMano(self.agarrarCarta())})})
    }
    
    method anadirJugadores(jugador) = jugadores.add(jugador)

    method jugada(jugador) {
            const cartasARemover = jugador.mostrarCartasAJugar()
            cartasARemover.forEach({ _carta => mesa.remove(_carta)})
    }

    method cambiarTurno() {
        const jugadorActual = self.jugadorConTurno()
        const proximoJugador = jugadores.find({ j => j != jugadorActual })
        jugadorActual.turno(0)
        proximoJugador.turno(1)
    }

    method contarPuntos() {
        jugadores.forEach({_jugador => 
            if (_jugador.tengoMayorCantidadCartas()) _jugador.sumarPuntaje()
            if (_jugador.tengo7deVelo()) _jugador.sumarPuntaje()
            if (_jugador.tengoSetenta()) _jugador.sumarPuntaje()
            if (_jugador.tengoTodosOros()) {
                (1..2).forEach({x => _jugador.sumarPuntaje()})
            } else if (_jugador.tengoMayorCantidadOros()) {
                _jugador.sumarPuntaje()
            }
            _jugador.contabilizarEscobas()
        })
    }

}
