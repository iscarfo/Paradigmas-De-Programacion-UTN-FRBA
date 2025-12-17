
//PERSONAS:
class Persona{
  var cantMonedas = 20
  var edad

  method ganarMonedas(n){
    cantMonedas+=n
  }

  method gastarMonedas(n){
    cantMonedas-=n
  }

  method cantRecursos() = cantMonedas

  method cumplirAnios() {
    edad+=1
  }

  method esDestacado() = edad.between(18, 65) || self.cantRecursos() > 30

  method trabajar(tiempo,planeta){}
}

//Personas de prueba:
const p1=new Persona(edad=20)
const p2=new Persona(edad=21)
const p3=new Persona(edad=22)
const p4=new Persona(edad=17)

class Productor inherits Persona {
  const tecnicas = [cultivo]

  override method cantRecursos() = super() * tecnicas.size()

  override method esDestacado() = super() || tecnicas.size() > 5

  method conoceTecnica(tecnica) = tecnicas.contains(tecnica)

  method realizarTecnica(tecnica,tiempo) {
    if(self.conoceTecnica(tecnica)) self.ganarMonedas(3*tiempo) //(3*tiempo).times{self.ganarMonedas(1)} OTRA OPCION
    else self.gastarMonedas(1)
  }

  method aprenderTecnica(tecnica) {
    tecnicas.add(tecnica)
  }

  override method trabajar(tiempo,planeta){
    if(planeta.viveEnPlaneta(self)) {
      const ultimaTecnica = tecnicas.last()
      self.realizarTecnica(ultimaTecnica, tiempo)
    }
  }
}

object cultivo{}

const pr1 = new Productor (edad=21)

class Constructor inherits Persona{
  const construcciones
  const region

  override method cantRecursos() = super() + 10*construcciones.size()

  override method esDestacado() = construcciones.size() > 5

  override method trabajar(tiempo, planeta) {
    const cons = region.construccion(tiempo,self) //Para no comparar objetos con un if gigante declaras el metodo en cada objeto
    construcciones.add(cons) 
    planeta.aniadirConstruccion(cons)  
    self.gastarMonedas(5)
  }

  method esInteligente() = construcciones.size() > 15
}

//Constructores de prueba:
const c1 = new Constructor (edad=20,construcciones=[],region=montania)
const c2 = new Constructor (edad=22,construcciones=[museo6y10],region=costa)


object montania{
  method construccion (tiempo,construc) = new Muralla (longitud=tiempo/2)
}

object costa{
  method construccion (tiempo,construc) = new Museo (superficie=tiempo,indice=1)
}

object llanura{
  method construccion (tiempo,construc) {
    if (!construc.esDestacado()) new Muralla (longitud=tiempo/2)
    else new Museo (indice=construc.cantRecursos(),superficie=tiempo)
  }
}

object bosque{
  method construccion (tiempo,construc) {
    if (!construc.esInteligente()) new Muralla (longitud=tiempo/2)
    else new Museo (indice=construc.cantRecursos(),superficie=tiempo)
  }
}

//Construcciones
class Muralla{
  const longitud

  method valor() = 10 * longitud
}

//Muralla de pruebas:
const muralla7 = new Muralla (longitud=7)
const muralla8 = new Muralla (longitud=8)

class Museo{
  const indice
  const superficie

  method valor() = indice.min(5).max(1) * superficie 
}

//Museos de prueba: 
const museo6y10 = new Museo (indice=6,superficie=10)

//Planetas
class Planeta {
  const habitantes //Personas que viven en el planeta
  const property construcciones

  method delegacionDiplomatica() {
    const coleccionAux=habitantes.filter{habitante=>habitante.esDestacado()} + [habitantes.max{habitante=>habitante.cantRecursos()}] //AL SER UN ELEMENTO LO PONGO ENTRE CORCHETES PARA HACER LA CONCATENACION
    return coleccionAux.asSet()
  } 
  method esValioso() = self.sumaPoderConstrucciones() > 100

  method sumaPoderConstrucciones() = construcciones.sum{construccion=>construccion.valor()}

  method viveEnPlaneta(persona) = habitantes.contains(persona)

  method aniadirConstruccion(cons) {construcciones.add(cons)}

  method trabajar (tiempo) {
    self.delegacionDiplomatica().forEach({persona=>persona.trabajar(tiempo,self)})
    }

  method invasion (tiempo,planeta) {
    planeta.delegacionDiplomatica().trabajar(tiempo)
  }
}

//Planeta de Prueba:

const planetaPrueba1 = new Planeta (habitantes=[p1,p2,p3,p4],construcciones=[muralla7,muralla8,museo6y10])
const planetaPrueba2 = new Planeta (habitantes=[p1,p2,p3,p4],construcciones=[])
const planetaPrueba3 = new Planeta (habitantes=[c1,c2,pr1],construcciones=[])
