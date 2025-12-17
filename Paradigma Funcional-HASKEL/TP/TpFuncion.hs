data Ciudad = UnaCiudad{
    nombre::String,
    anio::Float,
    atracciones::[String],
    costoVida::Float
}deriving Show

--Punto 1:
valorCiudad::Ciudad->Float
valorCiudad ciudad
    | anio ciudad < 1800 = 5*(1800-anio ciudad)
    | null (atracciones ciudad) = 2*costoVida ciudad
    | otherwise = 3*costoVida ciudad

--Punto 2:

algunaAtraccionCopada::Ciudad->Bool
algunaAtraccionCopada ciudad = any (esVocal) (atracciones ciudad)

esVocal::String->Bool
esVocal palabra = elem palabra ["AEIOUaeiou"]

ciudadSobria::Int->Ciudad->Bool
ciudadSobria n ciudad = all ((>n).length) (atracciones ciudad)

ciudadNombreRaro::Ciudad->Bool
ciudadNombreRaro ciudad = (length.nombre) ciudad < 5

--Punto 3:

calcularPorcentaje::Float->Float->Float
calcularPorcentaje a b = (a*b)/100

sumarAtraccion::String->Ciudad->Ciudad
sumarAtraccion atraccion ciudad = ciudad{atracciones=atracciones ciudad ++ [atraccion],costoVida=costoVida ciudad * 1.20}

crisis::Ciudad->Ciudad
crisis ciudad = ciudad{atracciones=init (atracciones ciudad),costoVida=costoVida ciudad * 0.90}

remodelacion::Float->Ciudad->Ciudad
remodelacion n ciudad = ciudad{nombre="New " ++ nombre ciudad,costoVida=costoVida ciudad + calcularPorcentaje (costoVida ciudad) n}

reevaluacion::Int->Ciudad->Ciudad
reevaluacion n ciudad 
    | ciudadSobria n ciudad = ciudad{costoVida=costoVida ciudad * 1.10}
    | otherwise = ciudad{costoVida=costoVida ciudad - 3}

--Punto 4:
transformacion::Float->Int->Ciudad->Ciudad
transformacion a b = (reevaluacion b.crisis.remodelacion a) 

data Anio = UnAnio{
    numero::Int,
    eventos::[Ciudad->Ciudad]
}

aplicarEvento::Ciudad->(Ciudad->Ciudad)->Ciudad
aplicarEvento ciudad condicion = condicion ciudad

pasoDeUnAnio::Anio->Ciudad->Ciudad
pasoDeUnAnio anio ciudad = foldl (aplicarEvento) ciudad (eventos anio)

algoMejor::(Ciudad->Float)->Ciudad->(Ciudad->Ciudad)->Bool
algoMejor criterio ciudad evento = criterio (evento ciudad) > criterio ciudad

costoDeVidaSuba::Anio->Ciudad->Ciudad
costoDeVidaSuba anio ciudad = foldl (aplicarEvento) ciudad (filter (algoMejor costoVida ciudad) (eventos anio))

costoDeVidaBaje::Anio->Ciudad->Ciudad
costoDeVidaBaje anio ciudad = foldl (aplicarEvento) ciudad (filter (not.(algoMejor costoVida ciudad)) (eventos anio))

valorSuba::Anio->Ciudad->Ciudad
valorSuba anio ciudad = foldl (aplicarEvento) ciudad (filter (algoMejor valorCiudad ciudad) (eventos anio))

--Punto 5:
eventosOrdenados::Anio->Ciudad->Bool
eventosOrdenados (UnAnio _ []) _ = True
eventosOrdenados (UnAnio _ [_]) _ = True
eventosOrdenados (UnAnio num (e1:e2:es)) ciudad = costoVida (e1 ciudad) < costoVida (e2 ciudad) && eventosOrdenados (UnAnio num (e2:es)) ciudad

ciudadesOrdenadas :: (Ciudad->Ciudad) -> [Ciudad] -> Bool
ciudadesOrdenadas _ [] = True --Para que termine la recursividad
ciudadesOrdenadas _ [_] = True
ciudadesOrdenadas evento (c1:c2:cs) = costoVida (evento c1) <= costoVida (evento c2) && ciudadesOrdenadas evento (c2:cs)

aniosOrdenados :: [Anio] -> Ciudad -> Bool
aniosOrdenados [] _ = True --Para que termine la recursividad
aniosOrdenados [_] _ = True
aniosOrdenados (a1:a2:as) ciudad = costoVida (pasoDeUnAnio a1 ciudad) <= costoVida (pasoDeUnAnio a2 ciudad) && aniosOrdenados (a2:as) ciudad

