data Auto = UnAuto{
    color::String,
    velocidad::Int,
    distanciaRecorrida::Int
}deriving Show

type Carrera = [Auto]

--Punto 1:
estaCerca::Auto->Auto->Bool
estaCerca auto1 auto2 = color auto1 /= color auto2 && abs(distanciaRecorrida auto1 - distanciaRecorrida auto2) < 10

tieneMayorDistancia::Auto->Auto->Bool
tieneMayorDistancia auto1 auto2 = distanciaRecorrida auto1>distanciaRecorrida auto2

vaTranquilo::Carrera->Auto->Bool
vaTranquilo carrera auto = all (tieneMayorDistancia auto) carrera && not (all (estaCerca auto) carrera)
--                         otra opcion es map distancia y 
--                                sacar maximum
--vaTranquilo carrera auto = (maximum.map distanciaRecorrida) carrera == distanciaRecorrida auto && not (all (estaCerca auto) carrera)

tieneMenorDistancia::Auto->Auto->Bool
tieneMenorDistancia auto1 auto2 = distanciaRecorrida auto1<distanciaRecorrida auto2

puesto::Carrera->Auto->Int
puesto carrera auto = 1 + length (filter (not.tieneMayorDistancia auto)  carrera)

--Punto 2:
correr::Int->Auto->Auto
correr n auto = auto {distanciaRecorrida=distanciaRecorrida auto + (n*velocidad auto)}

modificarVelocidad::(Int->Int)->Auto->Auto
modificarVelocidad modificador auto = auto {velocidad=max 0 (modificador (velocidad auto))}

bajarVelocidad::Int->Auto->Auto
bajarVelocidad n auto = modificarVelocidad (\v -> v - n) auto 
--bajarVelocidad n auto = modificarVelocidad (flip (-) n)  auto

--Punto 3:
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista


terremoto::Carrera->Auto->Carrera
terremoto carrera auto = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50) carrera

miguelitos::Int->Carrera->Auto->Carrera
miguelitos n carrera auto = afectarALosQueCumplen (tieneMenorDistancia auto) (bajarVelocidad n) carrera

jetPack::Int->Carrera->Auto->Carrera
jetPack n carrera auto = afectarALosQueCumplen ((== color auto) . color) (habilidadJetPack n) carrera

habilidadJetPack::Int->Auto->Auto
habilidadJetPack n auto = auto{distanciaRecorrida=(distanciaRecorrida(correr n auto)) + n*(velocidad auto)}

--Punto 4:

type Color=String

producirEvento::Carrera->(Carrera->Carrera)->Carrera
producirEvento carrera funcion = funcion carrera

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = map (\auto->(puesto (foldl producirEvento carrera eventos) auto, color auto)) (foldl producirEvento carrera eventos)

correnTodos::Int->Carrera->Carrera
correnTodos n carrera = map (correr n) carrera

usaPowerUp :: (Auto->Carrera->Carrera) -> String -> Carrera -> Carrera
usaPowerUp powerUp colorBusco carrera = powerUp (obtenerAutoPorColor colorBusco carrera) carrera

obtenerAutoPorColor :: String -> Carrera -> Auto
obtenerAutoPorColor colorBuscado carrera = (head.(filter ((==colorBuscado).(color)))) carrera 