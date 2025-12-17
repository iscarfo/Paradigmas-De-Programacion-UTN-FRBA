class Bots{
    var property cargaElectrica //solo la puse property para q no me de error, pero esta mal
    var property tipoAceite
}

class BotEstudiante inherits Bots{
    var property casaHogwart
    const hechizosAprendidos

    method aprenderHechizo (hechizo) {hechizosAprendidos.add(hechizo)}

    method modificarCargaElectrica (n) {cargaElectrica+=n}

    method ponerEnCero () {cargaElectrica=0}

    method darCarga() = cargaElectrica

    method darHechizos() = hechizosAprendidos

    method lanzarHechizo (hechizo,otro) {
        if (hechizosAprendidos.contains(hechizo) && self.estaActivo() && hechizo.condiciones())
        hechizo.consecuencias(otro)
        else throw new Exception (message="No se pudo lanzar el hechizo")
    }

    method estaActivo() = cargaElectrica != 0

    method esExperimentado () = hechizosAprendidos.size() > 3 && cargaElectrica > 50
}

class BotProfesor inherits BotEstudiante{
    var cantMateriasDadas  

    override method modificarCargaElectrica (n) {}

    override method ponerEnCero() {
      cargaElectrica=cargaElectrica/2
    }

    method agregarMateria() {cantMateriasDadas+=1}

    override method esExperimentado() = cantMateriasDadas>=2

}

class Materia{
    const profesor // para q no me salga error
    const hechizo
    const estudiantes

    method darMateria(){
        estudiantes.forEach({est=>est.aprenderHechizo(hechizo)})
        profesor.agregarMateria()
    }
}

object sombreroSeleccionador{
    var cont = 0

    method aQueCasaPertenece(estudiante) {
        const casasDisponibles //= [gryffindor, slytherin, ravenclaw y hufflepuff]
        const casa = casasDisponibles.get(cont)
        cont+=1
        if(cont==5) cont=0
        casa.agregarIntegrante(estudiante)
        return casa
    }
}

class Casa{
    const integrantes

    method agregarIntegrante(estudiante) = integrantes.add(estudiante)

    method esPeligrosa()

    method lanzarHechizo (hechizo,maligno) {
        integrantes.forEach({est=>est.lanzarHechizo(est.darHechizos().last(), maligno)})
    }
}

class Gryffindor inherits Casa{
    override method esPeligrosa() = false
}

class Slytherin inherits Casa{
    override method esPeligrosa() = true
}

class Ravenclaw inherits Casa{

    override method esPeligrosa() = integrantes.count({est=>est.tipoAceite()=="sucio"}) > 
    integrantes.count({est=>est.tipoAceite()=="puro"})
}

class Hufflepuff inherits Casa{
    
    override method esPeligrosa() = integrantes.count({est=>est.tipoAceite()=="sucio"}) > 
    integrantes.count({est=>est.tipoAceite()=="puro"})
}

class Hechizo{
    method consecuencias (estudiante)

    method condiciones (estudiante)
}

class HechizoComun inherits Hechizo{
    const n

    override method consecuencias (estudiante) {
        estudiante.modificarCargaElectrica(-n)
    }

    override method condiciones (estudiante) = estudiante.darCarga() > n
}

object inmobilus inherits Hechizo{
    override method consecuencias (estudiante) {
        estudiante.modificarCargaElectrica(-50)
    }

    override method condiciones (estudiante) {}
}

object sectumSempra inherits Hechizo{
    override method consecuencias (estudiante) {
        if(estudiante.tipoAceite()=="puro")
        estudiante.tipoAceite("sucio")
    }

    override method condiciones (estudiante) = estudiante.esExperimentado()
}

object avadakedabra inherits Hechizo{
    override method consecuencias (estudiante) {
        estudiante.ponerEnCero()
    }

    override method condiciones (estudiante) = estudiante.tipoAceite() == "puro" || 
    estudiante.casaHogwart().esPeligrosa()
}