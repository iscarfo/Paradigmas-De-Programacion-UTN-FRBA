class Jugador{
    const property nombre
    var property edad
    var property peso
    var property altura
    var property goles
    var property asistencias
    var partidosJugados

    method sumarPartido() {partidosJugados+=1}

    method puntaje() = partidosJugados
}

class Arquero inherits Jugador{
    var property golesRecibidos

    method promedioGolesRecibidos() = golesRecibidos/partidosJugados

    method esEstrella() = partidosJugados>100 && self.promedioGolesRecibidos()<0.8 || altura>1.90

    override method puntaje() = super()*2 + goles*500 - golesRecibidos

}

class Defensor inherits Jugador{
    var property rojas
    var property amarillas

    method promedioAmarillas() = amarillas/partidosJugados

    method esEstrella() = partidosJugados>150 && self.promedioAmarillas()<0.5 && rojas>5

    override method puntaje() = super()*3 + goles*5 - amarillas - rojas*10
}

class Mediocampista inherits Jugador{
    const jugoSeleccion

    method esEstrella() = partidosJugados>250 && goles>20 && asistencias>80 && jugoSeleccion || nombre.endsWith("inho")

    override method puntaje() = super() + goles*2 + asistencias*3 +
    if(jugoSeleccion) 100
    else 0
}

class Delnatero inherits Jugador{
    method esEstrella() = true

    override method puntaje() = 1500
}

class Equipo{
    const property jugadores
    var puntos

    method sumarPuntos(n) {puntos+=n}

    method mostrarPuntos() = puntos

    method permiteEquipo()

    method cantEstrellas() = jugadores.count({jug=>jug.esEstrella()})

    method habilidad () = jugadores.sum{jug=>jug.puntaje()}

    method tieneMejorEquipo(equipoRival) = self.habilidad() > equipoRival.habilidad()

    method estaBien()

}

class EquiposPro inherits Equipo{
    override method permiteEquipo() = jugadores.filter{jug=>jug.esEstrella()}.size() <= 9

    override method estaBien () = if(self.jugadores().any{jug=>jug.nombre()=="Messi"}) self.mostrarPuntos()>=18
    else self.mostrarPuntos()>=12
}

class EquiposMedioPelo inherits Equipo{
    override method permiteEquipo() = jugadores.filter{jug=>jug.esEstrella()}.size() <= 3

    override method estaBien() = self.mostrarPuntos() >= self.cantEstrellas()
}

class Brasil inherits Equipo{
    override method permiteEquipo() = true

    override method estaBien() = self.mostrarPuntos() >= 21
}

//Segunda Parte:

class Partido{
    const equipoLocal
    const equipoVisitante

    method equiposCompletos (e1,e2) = e1.jugadores().size() == 11 && e2.jugadores().size() == 11

    method puntajeEquipoLocal() = equipoLocal.cantEstrellas() + 
    if(equipoLocal.tieneMejorEquipo(equipoVisitante)) 5
    else 0
    + 1

    method puntajeEquipoVisitante() = equipoVisitante.cantEstrellas() + 
    if(equipoVisitante.tieneMejorEquipo(equipoLocal)) 5
    else 0

    method jugarPartido(equipo1,equipo2) {
        if(self.equiposCompletos(equipoLocal,equipoVisitante)){
            equipoLocal.jugadores().forEach({jug=>jug.sumarPartido()})
            equipoVisitante.jugadores().forEach({jug=>jug.sumarPartido()})
            if(self.puntajeEquipoLocal()>self.puntajeEquipoVisitante())
            equipoLocal.sumarPuntos(3)
            else if (self.puntajeEquipoLocal()<self.puntajeEquipoVisitante())
            equipoVisitante.sumarPuntos(3)
            else {equipoLocal.sumarPuntos(1)
            equipoVisitante.sumarPuntos(1)}
        }
        else throw new Exception(message="Los Equipos no estan completos")
    }
}

class Mundial inherits Partido{
    const equipos

    method jugarPartidos() {equipos.forEach{eq=>eq.forEach({equ=>self.jugarPartido(eq, equ)})}}

    method huboBatacazo() {
        self.jugarPartidos()
        const listaAux = equipos.filter{eq=>eq.mostrarPuntos()>=1 && eq.cantEstrellas()<2}
        return listaAux.size() >= 1
    }

    method estamosBien() = equipos.all{eq=>eq.estaBien()}

}