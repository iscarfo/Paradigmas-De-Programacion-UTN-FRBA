object pepita
{
    var energia = 100

    method volar(cuanto) //Accion
    {
        energia -= cuanto*10
    }

    method estaCansada() = energia<=20 //Consulta

    method comer(comida)
    {
        energia = energia + comida.energia()
    }
}

object alpiste
{
    method energia() = 5
}

//Agregado:
object milanesa 
{
    const gramos = 100
    method energia() = gramos/5
}

object manzana
{
    var energia_ = 50
    var porcentajeMaduracion = 0 // Inicialmente 0% de maduración
    var podrida = false

    method energia() = energia_

    method madurar() 
    {
        if (!podrida) 
        {
            if (porcentajeMaduracion < 100) {
                porcentajeMaduracion += 10
                energia_ = 50 + (porcentajeMaduracion / 10) * 5 // Incrementa las calorías hasta 100
            } 
            if (porcentajeMaduracion == 100) {
                podrida = true // Empieza a pudrirse
            }
        } 
        else 
        {
            energia_ -= 20 // Pierde 20 calorías cuando se pudre
            if (energia_ < 0) 
            {
                energia_ = 0 // No puede otorgar menos de 0 calorías
            }
        }
    }
}
