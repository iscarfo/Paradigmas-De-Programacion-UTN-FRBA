--Parte 1:
data Nomus = UnNomus {tieneAlas::Bool, cantBrazos::Int, cantOjos::Int, colorPiel::String, cantVida::Int,cantFuerza::Int}

--puedeVer :: Nomus -> Bool
--puedeVer (UnNomus _ _ ojos _ _ _) = ojos > 0

{-

categoria :: Nomus -> String
categoria (UnNomus _ _ _ _ _ fuerza)
    | fuerza > 10000 = "high-end"
    | fuerza > 3000 = "fuertes"
    | fuerza > 1000 = "comunes"
    | otherwise = "pichi"

--Parte 2:
--data Poder = UnPoder {cantCuracion::Int,cantDanio::Int,rangoAtaque::Int,danioCritico::Int}
--data Nomus = UnNomus {tieneAlas::Bool, cantBrazos::Int, cantOjos::Int, colorPiel::String, cantVida::Int,cantFuerza::Int,poderes::[Poder]}

probaDanioCritico :: [Poder] -> Int
probaDanioCritico poder = danioCritico (last poder)

esCuerpoAcuerpo :: Poder -> Bool
esCuerpoAcuerpo poder = rangoAtaque poder < 100

solamenteCuracion :: Poder -> Bool
solamenteCuracion poder = cantDanio poder == 0 && cantCuracion poder > 0
-}

--Entrenando Nomus
entrenarNomus :: Nomus -> Int -> Nomus
entrenarNomus nomus tiempo = UnNomus{tieneAlas=tieneAlas nomus, cantBrazos=cantBrazos nomus, cantOjos=cantOjos nomus, colorPiel=colorPiel nomus, cantVida=cantVida nomus,cantFuerza=cantFuerza nomus + tiempo}

{-
la funcion irAlGimnasio hace lo mismo que entrenar durante 15 minutos.
1) dada una lista de nomus, se quiere hacer que todos vayan al gimnasio

2) dada una lista de nomus, queremos saber quienes tienen alas

3) dada una lista de nomus, queremos saber si todos son poderosos
  
un nomus es poderoso cuando su fuerza es mayor a 35

4) dada una lista de nomus se quiere saber si los que tienen mas de un
brazo son poderosos

5) dada una de lista se quiere saber si despues de ir al gimnasio
quienes son poderosos
-}

--Fuuncion:
irAlGym :: Nomus -> Nomus
irAlGym nomus = entrenarNomus nomus 15

--Punto 1:
todosAlGym :: [Nomus] -> [Nomus]
todosAlGym nomus = map irAlGym nomus

--Punto 2:
aux1 :: Nomus -> Bool
aux1 nomus = tieneAlas nomus

tienenAlas :: [Nomus] -> [Nomus]
tienenAlas nomus = filter aux1 nomus

--Punto 3:
poderoso :: Nomus -> Bool
poderoso nomus = cantFuerza nomus > 35

todosPoderosos :: [Nomus] -> Bool
todosPoderosos nomus = all poderoso nomus

--Punto 4:
masDeUnBrazo :: Nomus -> Bool
masDeUnBrazo nomus = cantBrazos nomus >=1

soloBrazos :: [Nomus] -> [Nomus]
soloBrazos nomus = filter masDeUnBrazo nomus

poderBrazos :: [Nomus]->Bool
poderBrazos nomus = (todosPoderosos.soloBrazos) nomus

--Punto 5:
quienEsPoderoso :: [Nomus]->[Nomus]
quienEsPoderoso nomus = filter poderoso nomus

poderosoDespuesDeGym :: [Nomus] -> [Nomus]
poderosoDespuesDeGym nomus = (quienEsPoderoso.todosAlGym) nomus


