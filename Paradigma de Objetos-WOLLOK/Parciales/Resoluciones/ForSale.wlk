class Alquiler{
    const cantMesesContrato
    const property inmueble
    

    method comision() = (cantMesesContrato * inmueble.valor()) / 50000
}

class Empleado {
    const property operaciones
    const property reservas

    method realizarOperacion(op) = operaciones.add(op)

    method comision() = operaciones.sum({op=>op.comision()})

    method reservar(inmueble) = reservas.add(inmueble)

    method efectuarReserva(cliente,inmueble) {
        if(!inmueble.estaReservada() || (inmueble.estaReservada() && inmueble.duenio()!=cliente)){
            inmueble. modificarValorReserva()
            inmueble.modificarDuenio(cliente)
            self.realizarOperacion(inmueble.operacion())
            self.reservar(inmueble)
        }
        else{
            throw new Exception (message="Esa propiedad está reservada a otro nombre")
        }
    }

    method mejorEmpleadoSegun(listaEmpleados,criterio) = listaEmpleados.max{empleado=>empleado.criterio()}

    method totalDeComisiones() = self.comision()

    method cantOperaciones() = operaciones.size()

    method cantReservas() = reservas.size()

    method vaAtenerProblemasCon(otroEmpleado) = self.cerraronEnMismaZona(self,otroEmpleado) && self.seSabotearon(self,otroEmpleado)

    method cerraronEnMismaZona(empleado1,empleado2) { 
        const lista1 = empleado1.operaciones().map({op=>op.inmueble().zona()})
        const lista2 = empleado2.operaciones().map({op=>op.inmueble().zona()})
        return lista1.intersection(lista2).size() >=1
    }

    method seSabotearon(empleado1,empleado2) {
        const lista1 = empleado1.reservas().map{res=>res.inmueble()}
        const lista2 = empleado2.operaciones().map({op=>op.inmueble()})
        const lista3 = empleado2.reservas().map{res=>res.inmueble()}
        const lista4 = empleado1.operaciones().map({op=>op.inmueble()})
        return lista1.intersection(lista2).size() >=1 || lista3.intersection(lista4).size() >=1
    }
}
class Venta{
    var property porcentajeInmueble
    const property inmueble
    

    method comision() = (porcentajeInmueble/100) * inmueble.valor()
    method puedeVenderse(inmueblee) = ! inmueblee.esLocal()
}

class Inmueble{
    const property tamanioM2
    const property cantAmbientes
    const property operacion
    const property zona
    var property duenio

    
    var estaReservada = false

    method modificarValorReserva() {
        estaReservada = !estaReservada
    }

    method modificarDuenio(nuevo){
        duenio = nuevo
    }


    method valor() = zona.plus()
}

class Casa inherits Inmueble{
    const valorParticular

    override method valor () = super() + valorParticular
}

class Ph inherits Inmueble{

    override method valor () = super() + 14000*tamanioM2.max(500000)
}

class Depto inherits Inmueble{

    override method valor () = super() + 350000*cantAmbientes
}

class Local inherits Casa{
    const tipoLocal

    method esLocal() = true


    override method valor() = tipoLocal.precio()
}

class Galpon inherits Local {

    method precio() = valorParticular/2
}

class AlaCalle inherits Local {
    const montoFijo

    method precio () = montoFijo
}

class Zona {
    var property plus
}

class Cliente {

    method realizarReserva(empleado,propiedad) = empleado.efectuarReserva(self,propiedad)
}