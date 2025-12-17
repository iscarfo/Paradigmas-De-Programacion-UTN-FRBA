data Personaje = UnPersonaje{
    nombre::String,
    dinero::Int,
    felicidad::Int
}deriving Show

cambioFelicidad::Int->Int->Int
cambioFelicidad n m = max (n+m) 0

--1) Actividades:

irEscuela::Personaje->Personaje
irEscuela pj
    | nombre pj /= "Lisa" = pj{felicidad=cambioFelicidad(felicidad pj) (-20)}
    | otherwise = pj{felicidad=cambioFelicidad (felicidad pj) 20}

comerDonas::Personaje->Int->Personaje
comerDonas pj n = pj{felicidad=cambioFelicidad (felicidad pj) (10*n),dinero=(dinero pj)-10*n}

trabajar::String->Personaje->Personaje
trabajar trabajo pj = pj{dinero=dinero pj + length trabajo}

trabajarComoDirector::Personaje->Personaje
trabajarComoDirector pj = (trabajar "Escuela Elemental" . irEscuela) pj

--Act inventada: tocar saxofon
tocarSaxofon::Personaje->Personaje
tocarSaxofon pj
    | nombre pj /= "Lisa" = pj{felicidad=cambioFelicidad(felicidad pj) (-10)}
    | otherwise = pj{felicidad=cambioFelicidad (felicidad pj) 30}

homero::Personaje
homero = UnPersonaje "Homero" 20 50
--ghci> comerDonas homero 12
--UnPersonaje {nombre = "Homero", dinero = -100, felicidad = 170}

skinner::Personaje
skinner = UnPersonaje "Skinner" 0 30
--ghci> trabajarComoDirector skinner
--UnPersonaje {nombre = "Skinner", dinero = 17, felicidad = 10}

lisa::Personaje
lisa = UnPersonaje "Lisa" 0 100
--ghci> (tocarSaxofon.irEscuela) lisa
--UnPersonaje {nombre = "Lisa", dinero = 0, felicidad = 150}

--2) Logros

burns::Personaje
burns = UnPersonaje "Sr.Burns" 1000 10

serMillo::Personaje->Bool
serMillo pj = dinero pj > dinero burns

alegrarse::Int->Personaje->Bool
alegrarse n pj = felicidad pj > n

verProgramaKrosti::Personaje->Bool
verProgramaKrosti pj = dinero pj >= 10

--Inventado:
serAhorcadoPorHomero::Personaje->Bool
serAhorcadoPorHomero pj = nombre pj == "Bart"

--A)
actividadDecisiva::Personaje->(Personaje->Bool)->(Personaje->Personaje)->Bool
actividadDecisiva pj logro actividad = not(logro pj) && logro (actividad pj)

--B)
encontrarDecisiva::Personaje->(Personaje->Bool)->[(Personaje->Personaje)]->Personaje
encontrarDecisiva pj _ [] = pj
encontrarDecisiva pj logro (act1:acts)
    | actividadDecisiva pj logro act1 = act1 pj
    | otherwise = encontrarDecisiva pj logro acts

--C)
tareasParaHacerdeHomero::[(Personaje->Personaje)]
tareasParaHacerdeHomero = cycle [trabajar "Planta",irEscuela]
{- Si aplicas la funcion anterior con el logro de "serMillo" en algun momento lo conseguiria
por el dinero del trabajo y haskel por evaluacion diferida permitiría el resultado a pesar de
ser una lista infinita, sin embargo, si pones el logro de alegrarse con un n mayor a su
felicidad nunca lo conseguiria y haskel seguiria ejecutando la funcion infinitamente
hasta que de overflow o interrumpt-}

