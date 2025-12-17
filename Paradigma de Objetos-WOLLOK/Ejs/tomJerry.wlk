object tom {

    var energia = 50

    // Calcula la energía que Tom ganaría al comer un ratón sin modificar su energía actual
    method energiaGanadaComer(raton) {
        return 12 + raton.peso()
    }

    // Calcula la energía que Tom gastaría al correr una distancia sin modificar su energía actual
    method energiaGastadaCorrer(distancia) {
        return distancia / 2
    }

    // Método comer que modifica la energía de Tom cuando efectivamente come al ratón
    method comer(raton) {
        energia += self.energiaGanadaComer(raton)
    }

    // Método correr que modifica la energía de Tom cuando efectivamente corre
    method correr(distancia) {
        energia -= self.energiaGastadaCorrer(distancia)
    }

    method velocidadMaxima() {
        return 5 + energia / 10
    }

    // Puede comer si la energía que gastaría al correr es menor que su energía actual
    method puedeComer(raton, distancia) {
        return self.energiaGastadaCorrer(distancia) < energia
    }

    // Quiere comer si puede comer y además la energía que ganaría es mayor que la que gastaría
    method quiereComer(raton, distancia) {
        return self.puedeComer(raton, distancia) && self.energiaGanadaComer(raton) > self.energiaGastadaCorrer(distancia)
    }
}

object jerry {
	
    var edad = 2

    method cumplir ()
    {
        edad+=1
    }

    method peso () = edad * 20
}

object nibbles {

    method peso () = 35
}