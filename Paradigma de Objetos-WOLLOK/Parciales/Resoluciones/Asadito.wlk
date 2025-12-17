
class Persona{
    var property posicion
    var property elementosCerca
    const comidas = []

    method comioAlgo() = comidas.size() != 0

    method agregarComida(com) {comidas.add(com)}

    method mePasas(comensal,elemento){
        if(comensal.elementosCerca().contains(elemento))
        comensal.criterio(self,elemento)
        else throw new Exception (message="No tiene el elemento")
    }

    method eligeComer (bandeja)

    method comer (bandeja) {
        if(self.eligeComer(bandeja))
        self.agregarComida(bandeja)
    }

    method estaPipon () = comidas.any{com=>com.esPesada()}

    method laEstaPasandoBien () = self.comioAlgo()

    method comioCarne() = comidas.any({com=>com.esCarne()})
}

//Punto 4: (Este no esta muy bien)
object osky inherits Alternado(posicion=1,elementosCerca=[]){
} //Siempre la pasa bien

object moni inherits Alternado(posicion=1,elementosCerca=[]){
    override method laEstaPasandoBien() = super() && posicion == 1
}

object facu inherits Alternado(posicion=1,elementosCerca=[]){
    override method laEstaPasandoBien() = super() && self.comioCarne()
}

object vero inherits Alternado(posicion=1,elementosCerca=[]){
    override method laEstaPasandoBien() = super() && self.elementosCerca().size() <= 3
}

class Sordos inherits Persona{
    method criterio(persona,elemento){
        const primero = self.elementosCerca().first()
        self.elementosCerca().remove(primero)
        persona.elementosCerca().add(primero)
    }
}

class TodosLosElementos inherits Persona{
    method criterio(persona,elemento){
        persona.elementosCerca()+self.elementosCerca()
        self.elementosCerca([])
    }
}

class CambiarPosicion inherits Persona{
    method criterio(persona,elemento){
        const posA = self.posicion()
        const posB = persona.posicion()
        self.posicion(posB)
        persona.posicion(posA)
        const eleA = self.elementosCerca()
        const eleB = persona.elementosCerca()
        self.elementosCerca(eleB)
        persona.elementosCerca(eleA)
    }
}

class PasaElemento inherits Persona{
    method criterio(persona,elemento){
        self.elementosCerca().remove(elemento)
        persona.elementosCerca().add(elemento)
    }

}
class BandejaComida{
    const property calorias
    const property esCarne

    method esPesada() = calorias > 500
}

class Vegetariano inherits Persona{
    override method eligeComer (bandeja) = !bandeja.esCarne()
}

class Dietetico inherits Persona{
    var property valorOMS
    override method eligeComer (bandeja) = bandeja.calorias() < valorOMS
}

class Alternado inherits Persona{
    var property alternado = true
    override method eligeComer (bandeja) {
        self.alternado(!alternado)
        return alternado
    }
}

class Condiciones inherits Persona{
    const condiciones

    override method eligeComer (bandeja) = condiciones.all({cond=>bandeja.cond()})
}

//Punto 5:
// se usó herencia en el punto 1 para cumplir condiciones de tipos de personas, donde tambien necesito ejecutar un super() porque hay una condicion
// global además de la que tiene cada persona

// se usó composición en los puntos 1 y 2 porque si una persona quiere cambiar de preferencia o criterio lo puede hacer facilmente!

// se usó polimorfismo se aplica en casi todo el parcial, donde destacaría su implementación es en el sector de bandejas donde permite realizar 
// varios metodos siempre y cuando sea un objeto que entienda esos mensajes