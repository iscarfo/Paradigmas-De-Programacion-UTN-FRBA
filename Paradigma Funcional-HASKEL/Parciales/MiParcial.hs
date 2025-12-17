--Punto 1:
type Tribu = [Fremen]

data Fremen = UnFremen{nombre::String,toleranciaEspecia::Int, titulos::[String],cantReconocimientos::Int}deriving Show

--a)
recibirReconocimiento::Fremen->Fremen
recibirReconocimiento fremen = fremen {cantReconocimientos=cantReconocimientos fremen + 1}

--b)
hayCandidatoASerElegido::Tribu->Bool
hayCandidatoASerElegido = any esElegido

esElegido::Fremen->Bool
esElegido fremen = elem "Domador" (titulos fremen) && toleranciaEspecia fremen > 100

--c)
hallarElegido::Tribu->Fremen
hallarElegido = maximoSegun cantReconocimientos . filter esElegido

maximoSegun ::(Fremen -> Int) -> Tribu -> Fremen
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun ::(Fremen -> Int) -> Fremen -> Fremen -> Fremen
mayorSegun f fremen1 fremen2 
 | f fremen1 > f fremen2 = fremen1
 | otherwise = fremen2

--Punto 2:
data GusanoArena = UnGusanoArena{longitud::Int,nivelHidratacion::Int,descripcion::String} deriving Show

modificarPorcentaje::(Int->Int->Int)->Int->Int->Int
modificarPorcentaje modificador a b= modificador a (div (a*b) 100)

reproduccion::GusanoArena->GusanoArena->GusanoArena
reproduccion gusano1 gusano2 = UnGusanoArena {longitud= div ((max (longitud gusano1) (longitud gusano2))*10) 100 , nivelHidratacion=0 , descripcion = descripcion gusano1++" - "++descripcion gusano2}

--Gusanos de ejemplo:
gus1 :: GusanoArena
gus1 = UnGusanoArena 10 5 "Rojo con lunares"

gus2 :: GusanoArena
gus2 = UnGusanoArena 8 1 "Dientes puntiagudos"

reproduccionMasiva::[GusanoArena]->[GusanoArena]->[GusanoArena]
reproduccionMasiva [] [] = []
reproduccionMasiva [] [_] = []
reproduccionMasiva [_] [] = []
reproduccionMasiva (g1:gs1) (g2:gs2) = reproduccion g1 g2 : reproduccionMasiva gs1 gs2

--Punto 3:
aumentarToleranciaEspecia::Int->Fremen->Fremen
aumentarToleranciaEspecia n fremen = fremen{toleranciaEspecia=toleranciaEspecia fremen + n}

concatenar::String->Fremen->Fremen
concatenar palabra fremen = fremen{titulos=titulos fremen++[palabra]}

domarGusanoDeArena::GusanoArena->Fremen->Fremen
domarGusanoDeArena gusano fremen
 | toleranciaEspecia fremen >= div (longitud gusano) 2 = (aumentarToleranciaEspecia 100 . concatenar "Domador") fremen
 | otherwise = fremen{toleranciaEspecia=modificarPorcentaje (-) (toleranciaEspecia fremen) 10}

destruirGusanoDeArena::GusanoArena->Fremen->Fremen
destruirGusanoDeArena gusano fremen
 | elem "Domador" (titulos fremen) && toleranciaEspecia fremen < div (longitud gusano) 2 = (aumentarToleranciaEspecia 100.recibirReconocimiento) fremen
 | otherwise = fremen{toleranciaEspecia=modificarPorcentaje (-) (toleranciaEspecia fremen) 20}

--Act Inventada:
comerGusanoDeArena::GusanoArena->Fremen->Fremen
comerGusanoDeArena gusano fremen 
 | toleranciaEspecia fremen > 100 && nivelHidratacion gusano < 20 = (aumentarToleranciaEspecia 1000 . concatenar "Superviviente") fremen
 | otherwise = fremen{toleranciaEspecia=modificarPorcentaje (-) (toleranciaEspecia fremen) 80}

misionColectiva::GusanoArena->(GusanoArena->Fremen->Fremen)->Tribu->Tribu
misionColectiva gusano mision = map (mision gusano)

otroElegido::Tribu->(GusanoArena->Fremen->Fremen)->GusanoArena->Bool
otroElegido tribu mision gusano = (nombre.hallarElegido) tribu /= (nombre.hallarElegido.misionColectiva gusano mision) tribu

--Punto 4:
fremencito :: Fremen
fremencito = UnFremen "Carlos" 101 ["Crack","Lider","Domador"] 4

--Tribu infinita de Fremens
tribuLoca::[Fremen]
tribuLoca = repeat fremencito

--a)
{-En el caso de la funcion misionColectiva, la mision se ejecutaría infinitamente hasta que de overflow o una interrupcion, ya que Haskel funciona con evaluacion
diferida por lo que empieza a ejecutar la funcion antes de analizar los parámetros y puede operar con listas infinitas a pesar de que, en este caso, no podría
llegar a un resultado coherente
-}
--b)
{-En este caso, a diferencia de la anterior, se podría llegar a un resultado coherente ya que lo que busca la funcion es encontrar un solo elegido, por lo que,
si al ejecutar se encuentra, daría el resultado correcto por evaluación diferida, sin embargo, si no hay ningun candidato a ser elegido, pasará como la anterior
funcion ya que seguirá ejecutando infinitamente sin dar resultado
ejemplo: *Main> hayCandidatoASerElegido tribuLoca
True
Esto sucede ya que, a pesar de ser una lista infinita, encuentra al elegido
-}

--c)
{-En este caso, al igual que en la funcion explicada en el puntoA no se podría llegar a un resultado ya que se busca el maximo de una lista infinita por ende, nunca
se encuentra y se rompería la funcion-}
