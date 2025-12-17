class ArmaFilo{
    const filo
    const longitud


    method ataque() = (filo.min(1).max(0)) * longitud
}

class ArmaContundente{
    const peso

    method ataque() = peso
}

class Casco{
    method defensa()=10
}

class Escudo{
    const portador

    method defensa()=5+portador.destreza()*0.1

}

class Gladiador {
    var armas
    var armadura

    var vida = 100

    method modificarVida (n) {
        vida+=n
    }

    method modificarArmas (nuevasArmas) {
        armas=nuevasArmas
    }

    method agregarArma (arma) {
        armas.add(arma)
    }

    method modificarArmadura (nuevasArmadura) {
        armadura=nuevasArmadura
    }

    method agregarArmadura (nuevaArmadura) {
        armadura.add(nuevaArmadura)
    }

    method poderAtaque()

    method atacar(gladiador){
        const danio= self.poderAtaque() - gladiador.defensa()
        gladiador.modificarVida(danio)
    }

    method pelear(gladiador) {
        self.atacar(gladiador)
        gladiador.atacar(self)
    }

    method puedeCombatir() = vida>0

    method determinarCampeon() = self

    method curacion (n) {self.modificarVida(n)}    
}

class Mirmillon inherits Gladiador{
    var property fuerza
    const property destreza = 15

    override method poderAtaque () = fuerza + armas.sum{arma=>arma.ataque()}

    method defensa() = armadura.sum{arm=>arm.defensa()} + destreza

    method crearGrupo(otroGladiador) = new Grupo (gladiadores=[self,otroGladiador],
    nombre="mirmillolandia",
    cantPeleas=0)
}

class Dimarcheus inherits Gladiador (armadura=[]){
    const property fuerza = 10
    var property destreza

    override method atacar(gladiador){
        super(gladiador) //SUPER() CON PARAMETROS
        destreza+=1
    }

    override method poderAtaque () = fuerza + armas.sum{arma=>arma.ataque()}

    method defensa() = destreza/2

    method crearGrupo(otroGladiador) = new Grupo (gladiadores=[self,otroGladiador],
    nombre="D-"+(self.poderAtaque()+otroGladiador.poderAtaque()),
    cantPeleas=0)
}

class Grupo{
    const gladiadores
    var property nombre
    var property cantPeleas

    method agregarGladiador(gladiador) = gladiadores.add(gladiador)
    method quitarGladiador(gladiador) = gladiadores.remove(gladiador)

    method determinarCampeon () {
        const lista = gladiadores.filter{gla=>gla.puedeCombatir()}
        return lista.max{gla=>gla.fuerza()}
    }

    method curacion (n) {    
        gladiadores.forEach({gla=>gla.modificarVida(n)})
    }
}

object coliseo{

    method combate (grupo1,grupo2) {
        //Round 1:
        var g1=grupo1.determinarCampeon()
        var g2=grupo2.determinarCampeon()
        g1.pelear(g2)
        //Round 2:
        g1=grupo1.determinarCampeon()
        g2=grupo2.determinarCampeon()
        g1.pelear(g2)
        //Round 3:
        g1=grupo1.determinarCampeon()
        g2=grupo2.determinarCampeon()
        g1.pelear(g2)
    }

    method curar (grupo,n) {
        grupo.curacion(n)
    }

}