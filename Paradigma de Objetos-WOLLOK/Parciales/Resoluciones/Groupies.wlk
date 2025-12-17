class Artista{
    var property instrumento
    const property estilos
    var allegados = 0

    method calidad() = estilos.size()*5 + instrumento.puntaje()

    method haceEstilo(estilo) = estilos.contains(estilo)

    method ganarAllegadosPersona (recital) {
        if(self.calidad()>=15){
            allegados+=0.15*recital.cantGente().min(recital.cantGente()).max(0)
        }
        if(recital.duracion()<1){
            allegados-=0.03*recital.cantGente().min(recital.cantGente()).max(0)
        }
    }

    method sumarAllegados(cant){allegados+=cant}

}

const taylor = new Artista (instrumento=voz,estilos=[pop,rock,country])
const maikel = new Artista (instrumento=voz,estilos=[pop,soul])
const riorio = new Artista (instrumento=guitarraRiorio,estilos=[metal,heavyMetal])
const hellMusic = new Artista (instrumento=voz,estilos=[metal,deathMetal])
const truqillo = new Artista (instrumento=bajoRojoTruquillo,estilos=[rock,metal])
const emiliaViernes = new Artista (instrumento=voz,estilos=[cumbiaUru,pop])
const rengoEstar = new Artista (instrumento=bateria,estilos=[rock,pop])

class Estilo{}

const pop = new Estilo()
const rock = new Estilo()
const country = new Estilo()
const soul = new Estilo()
const metal = new Estilo()
const heavyMetal = new Estilo()
const deathMetal = new Estilo()
const cumbiaUru = new Estilo()


class Instrumento{
    method puntaje()
}
class GuitarraCriolla inherits Instrumento{
    var cuerdasSanas

    method agregarCuerda() {
      cuerdasSanas+=1
    }

    method seRompeCuerda() {
        cuerdasSanas-=1
    }

    override method puntaje() = 10 + cuerdasSanas

}

class GuitarraElectrica inherits Instrumento{
    const ampli

    override method puntaje() = 15 + ampli.potencia()
}

const guitarraRiorio = new GuitarraElectrica (ampli=marshall)

class Amplificador{
    const property potencia
}

//Ej:
const marshall = new Amplificador (potencia=7)

class Bajo inherits Instrumento{
    const musico
    const color

    override method puntaje() = 5 + 
    if(musico.estilos().contains(metal) && color=="rojo") 7
    else 2
}

const bajoRojoTruquillo = new Bajo (musico=truqillo,color="rojo")

class Bateria inherits Instrumento{
    const musico

    override method puntaje () = 10 +
    if(musico.estilos().contains(rock)) 10
    else 0
}

const bateria = new Bateria (musico=rengoEstar)

class Voz inherits Instrumento{
    var property valor

    override method puntaje () = valor
}

const voz = new Voz(valor=16)

class Banda{
    const integrantes
    var allegados = 0

    method puedenFormarBanda () = self.unSoloVocalista() && self.menosDe4() && self.tienenEstiloEnComun()
    
    method unSoloVocalista () {
        if(integrantes.filter({art=>art.instrumento()==voz}).size() <= 1) return true
        else throw new Exception (message="Hay mas de un solo vocalista")
    }

    method menosDe4 () {
        if(integrantes.size() <= 4) return true
        else throw new Exception (message="Son mas de 4")
    }

    method tienenEstiloEnComun() {
        const estilosIniciales = integrantes.first().estilos()
        const estilosComunes = estilosIniciales.filter{ estilo => integrantes.all{ integrante => 
        integrante.haceEstilo(estilo) }}
    
    if(!estilosComunes.isEmpty()) return true
    else throw new DomainException(message = "No tienen estilo en comun")
    }

    method personaConMasCalidad () = integrantes.max{int=>int.calidad()}

    method calidad (){
        const estilosGrupo = integrantes.filter({int=>int.estilos()}).asSet()


        return estilosGrupo.size()*5 + integrantes.size()*2 + integrantes.personaConMasCalidad().calidad()
    }

    method ganarAllegadosGrupo (recital,cant) {
        allegados+=cant
        self.personaConMasCalidad().sumarAllegados(cant)
    }

    method estaPegado() = allegados > 20000

}

class Recital{
    const property duracion
    const property invitados
    const property cantGente
    const property banda

}


