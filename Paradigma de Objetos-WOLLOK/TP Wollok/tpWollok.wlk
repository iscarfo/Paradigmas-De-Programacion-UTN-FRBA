// PERSONAJES
class Guerrero {
  const origen
  const armas 
  const elementosUtiles
  var vida

  method vidaActual () = vida
 
  method modificarVida(valor) {
  vida += valor
  vida= vida.min(100).max(0)
  }

  method sacarArma(arma){
    armas.remove(arma)
  }

  method elementosPropios () = elementosUtiles

  method armasPropias () = armas

  method origenGuerrero() = origen

  method cantArmas () = armas.size()

  method cantElementos () = elementosUtiles.size()

  method poder () //Metodo abstracto
    
  method sumaPoder () = armas.sum({arma=>arma.poder()})

  method estaArmado() = !armas.isEmpty()

  method asignarArma(arma) {
    armas.add(arma)
  }
}

class Hobbit inherits Guerrero {
    
  override method poder() = self.vidaActual() + self.cantElementos() * self.sumaPoder()

} 

class Enano inherits Guerrero {
  const factPoder

  override method poder() = self.vidaActual() + factPoder * self.sumaPoder()

}

class Elfo inherits Guerrero {
  var destrezaBase = 2
  const destrezaPropia

  method modificarBase(valor){destrezaBase=valor}

  override method poder () = self.vidaActual() + ((destrezaBase+destrezaPropia)*self.sumaPoder())
}

class Humano inherits Guerrero {
  const limitador

  override method poder () = self.vidaActual() + self.sumaPoder()/limitador
}

class Maiar inherits Guerrero {
  var factBajoAmenaza = 300
  var factBasico = 15

  method modificarValorfactBajoAmenaza(valor){factBajoAmenaza=valor}
  method modificarValorfactBasico(valor){factBasico=valor}
  
  method factActual() =if(vida<10) factBajoAmenaza else factBasico

  override method poder () = self.vidaActual() * self.factActual() + 2*self.sumaPoder()
}
class Gollum inherits Hobbit {
  override method poder() = super() / 2
}

object tomBomb {
  method poder () = 10000000

  method vidaActual () = 100

  method estaArmado() = true

  method modificarVida(valor){}
}

//ORIGENES

object elfico {
  method poder()=25
}
object humano {
  method poder()=15
}
object enano {
  method poder()=20
}
//OTROS
object hobbit{

}
object maiar{

}
object gollum{

}

//PRUEBA

const unEnano = new Enano(origen=enano,vida=100,armas=[],elementosUtiles=[],factPoder=1)

//MODELADOS DE GUERREROS

const frodo = new Hobbit (origen=hobbit,vida=50,elementosUtiles=[],armas=[])
const gimli = new Enano (origen=enano,vida=75,elementosUtiles=[],factPoder=3,armas=[hacha70y5,hacha70y5])
const legolas = new Elfo (origen=elfico,vida=80,destrezaPropia=1,elementosUtiles=[],armas=[])
const aragorn = new Humano (origen=humano,vida=85,elementosUtiles=[],limitador=20,armas=[])
const gandalf = new Maiar (origen=maiar,vida=100,elementosUtiles=[],armas=[]) 

// ARMAS

class Espada {
  var multiplicador
  var guerreroPortador

  method modificarMultiplicador(valor) {
  multiplicador += valor
  multiplicador= multiplicador.min(20).max(1)
  }

  method modificarGuerrero (nuevoGuerrero) {guerreroPortador=nuevoGuerrero}

  method origenGuerrero () = guerreroPortador.origenGuerrero()

  const origenesValidos = [elfico,humano,enano]

  method poder () {
    if (origenesValidos.contains(self.origenGuerrero()))
    {
      return multiplicador * self.origenGuerrero().poder()
    } 
    else 
    {
      return 10 * guerreroPortador.cantArmas()}
  }
}


class Daga inherits Espada {

 override method poder() = super() / 2
}


class Baculo {
  const poder

  method poder () = poder
}

const baculo = new Baculo (poder = 400)
class Hacha {
  var largoMango
  var pesoHoja

  method cambiarLargoMango(nuevaMedida){ largoMango = nuevaMedida}
  method cambiarPesoHoja(nuevoPeso) { pesoHoja = nuevoPeso}
  method poder() = largoMango * pesoHoja
}

//MODELADO DE ARMAS

const daga8 = new Daga (multiplicador=8, guerreroPortador=frodo)
const hacha70y5 = new Hacha (largoMango=70,pesoHoja=5)
const espada12 = new Espada (multiplicador=12,guerreroPortador=legolas)
const andruil = new Espada (multiplicador=18,guerreroPortador=aragorn)
const daga10 = new Daga (multiplicador=10,guerreroPortador=aragorn)
const glamdring = new Espada (multiplicador=18,guerreroPortador=gandalf)
const baculo400 = new Baculo (poder=400) 


// ZONAS

class ZonasPoder {
  const poderNecesario
  method pasadaPor (alguien) = alguien.poder() > poderNecesario && req30lembas.cumple([alguien])

  method consecuencias (alguien) {}
}

const lebennin = new ZonasPoder (poderNecesario = 1500)

class ZonasArmado {
  const vidaPerdida
  method pasadaPor (alguien) = alguien.estaArmado() && reqMasDe2Armas.cumple([alguien])

  method consecuencias (alguien) {
    alguien.modificarVida(-vidaPerdida)
  }
}

const minasTirith = new ZonasArmado (vidaPerdida=10)

object lossarnach {
  method pasadaPor (alguien){}

  method consecuencias (alguien) {
    alguien.modificarVida(1) 
  }
}

//CAMINOS

class CaminoTM {
  var camino
  
  method modificarCamino (zona1,zona2){
    camino = [zona1,zona2]
  }

  method pasadaPorGrupo(grupo) =
    camino.all { zona => 
        grupo.all { alguien => 
            zona.pasadaPor(alguien)
        }
    }
  

  method consecuenciasGrupo(grupo) {
    camino.forEach { zona => 
        grupo.forEach { alguien => 
            zona.consecuencias(alguien)
        }
    }
  }
  
}

const gondor = new CaminoTM (camino = [lebennin,minasTirith])
const otroCamino = new CaminoTM (camino = [minasTirith,lossarnach])

//REQUERIMIENTOS

class ReqElemento {
  const numero
  const elemento

  method cumple(grupo) = 
    grupo.sum({ alguien => 
      alguien.elementosPropios().count({ algo => algo == elemento })
    }) >= numero
}

const req30lembas = new ReqElemento (numero=30,elemento=lemba)

//ELEMENTO UTIL PARA EL EJEMPLO
object lemba{}

class ReqGuerrero {
  const criterio

  method cumple(grupo) = 
  grupo.any({ alguien => 
    criterio.apply(alguien)
  })
}

const reqMasDe2Armas = new ReqGuerrero(criterio={ alguien => alguien.armasPropias().size() >= 2 })