class Plato{
  const cantAzucar
  
  method esBonita()

  method darAzucar() = cantAzucar

  method cantCalorias() = 3 * cantAzucar + 100

  method serCatado(cocinero) = cocinero.catarPlato(self) 
}

class Entrada inherits Plato (cantAzucar=0){

  override method esBonita() = true

}

class Principal inherits Plato{
  const valor

  override method esBonita() = valor

}

class Postre inherits Plato (cantAzucar=120){
  const cantColores

  override method esBonita() = cantColores>3
}

class Cocinero{
  var especialidad

  const platos = []

  method darPlatos () = platos

  method cambiarEspecialidad(nueva) {especialidad=nueva}

  method cocinar() = especialidad.cocinar()

  method catarPlato(plato) = especialidad.catarPlato(plato)

  method participarEn(torneo) {
    torneo.add(self)
    const plato = self.cocinar()
    torneo.darPlatos().add(plato)
    platos.add(plato)
  }
}

class Pastelero inherits Cocinero{
  const nivelDulzor
  
  override method catarPlato(plato) = (5 * plato.darAzucar()/nivelDulzor).min(10)

  override method cocinar() = new Postre (cantColores=nivelDulzor/50)

}

class Chef inherits Cocinero{
  const caloriasDeseadas

  method casoAparte(plato) = 0

  override method cocinar () = new Principal (valor=true,cantAzucar=caloriasDeseadas)


  override method catarPlato(plato) = 
  if(plato.esBonito() && plato.cantCalorias()<=caloriasDeseadas)
  10
  else
  self.casoAparte(plato)
}

class Souschef inherits Chef{

  override method casoAparte (plato) = (plato.cantCalorias()/100).min(6)

  override method cocinar () = new Entrada ()

}

class Torneo{
  const catadores
  const cocineros
  const platos

  method darPlatos() = platos

  method cocineroGanador() {
    if(cocineros.isEmpty())
    throw new DomainException (message="No se presentaron cocineros")
    else{
      const platoGanador = platos.max({plato=>self.sumaCatadores(plato)})
      const ganador = cocineros.filter{cocinero=>cocinero.darPlatos().contains(platoGanador)}
      return ganador
    }
  }

  method sumaCatadores (plato) {catadores.sum({catador=>catador.catarPlato(plato)})}


}