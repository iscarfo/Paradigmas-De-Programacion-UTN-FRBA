data Personaje = UnPersonaje {
    nombre::String,
    dinero::Int,
    felicidad::Int
}deriving Show

--Parte 1: Actividades
--1)

calcularFelicidad::Int->Int
calcularFelicidad a = max 0 a

irEscuela::Personaje->Personaje
irEscuela personaje
    | nombre personaje == "Butters" = personaje {felicidad=calcularFelicidad (felicidad personaje + 20)}
    | otherwise = personaje {felicidad=calcularFelicidad (felicidad personaje - 20)}

comerCheesyPoofs::Int->Personaje->Personaje
comerCheesyPoofs n personaje = personaje{felicidad=calcularFelicidad (felicidad personaje + 10*n),dinero=dinero personaje - 10*n}

irTrabajar::String->Personaje->Personaje
irTrabajar trabajo personaje = personaje{dinero=dinero personaje + length trabajo}

dobleTurno::String->Personaje->Personaje
dobleTurno trabajo personaje = (irTrabajar trabajo . irTrabajar trabajo) personaje{felicidad=calcularFelicidad (felicidad personaje - length trabajo)}

jugarWOW::Int->Int->Personaje->Personaje
jugarWOW amigos tiempo personaje = personaje {felicidad=calcularFelicidad (felicidad personaje + amigos*(10*(min 5 tiempo))),dinero=dinero personaje - 10*tiempo}

matarAalguien::Personaje->Personaje->Personaje
matarAalguien victima asesino = asesino{felicidad=calcularFelicidad (felicidad asesino - 50),dinero= dinero asesino + dinero victima}

--2)

--Personajes Ejemplo:
cartman::Personaje
cartman = UnPersonaje "Eric Cartman" 10000 200
--comerCheesyPoofs 12 cartman
--UnPersonaje {nombre = "Eric Cartman", dinero = 9880, felicidad = 320}

stan = UnPersonaje "Stan" 1000 25
--dobleTurno "Barriendo La Nieve" stan
--UnPersonaje {nombre = "Stan", dinero = 1036, felicidad = 7}

butters = UnPersonaje "Butters" 50 50
--(matarAalguien stan . irEscuela) butters
--UnPersonaje {nombre = "Butters", dinero = 1050, felicidad = 20}

--Parte 2:
--Multiples Actividades:
--3)
repetirActividad::(Personaje->Personaje)->Int->Personaje->Personaje
repetirActividad _ 0 personaje = personaje
repetirActividad actividad n personaje = (repetirActividad actividad (n-1) . actividad) personaje

aplicarActividad::Personaje->(Personaje->Personaje)->Personaje
aplicarActividad personaje actividad = actividad personaje

aplicarTodasLasActividades::[(Personaje->Personaje)]->Personaje->Personaje
aplicarTodasLasActividades listaAct personaje = foldl (aplicarActividad) personaje listaAct

--4) Logros:

serMillo::Personaje->Bool
serMillo personaje = dinero personaje > dinero cartman

estarContento::Int->Personaje->Bool
estarContento n personaje = felicidad personaje > n

programaTandP::Personaje->Bool
programaTandP personaje = dinero personaje > 10

tenerNombreCapicua::Personaje->Bool
tenerNombreCapicua personaje = nombre personaje == (reverse . nombre) personaje

actividadDecisiva::(Personaje->Personaje)->(Personaje->Bool)->Personaje->Bool
actividadDecisiva actividad logro personaje = not (logro (actividad personaje)) && logro (actividad personaje)

paraCualEsDecisiva::[Personaje]->(Personaje->Personaje)->(Personaje->Bool)->[Personaje]
paraCualEsDecisiva listaPer actividad logro = filter (actividadDecisiva actividad logro) listaPer






