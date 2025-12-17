data Jugador = UnJugador {
    nombre:: String,
    puntaje:: Int,
    inventario:: [Material]
} deriving Show

data Receta = UnaReceta{
    materiales::[Material],
    tiempo::Int,
    resultado::Material
} deriving Show

type Material = String

fogata = UnaReceta ["Madera","Fosforo"] 10 "Fogata"

polloAsado = UnaReceta ["Fogata","Pollo"] 300 "Pollo Asado"

sueter = UnaReceta ["Lana","Agujas","Tintura"] 600 "Sueter"

intentarCraftear :: Receta -> Jugador ->  Jugador
intentarCraftear receta jugador
    | tieneMateriales receta jugador  =  craftear receta jugador 
    | otherwise = alterarPuntaje (-100) jugador 

craftear :: Receta -> Jugador -> Jugador
craftear receta = alterarPuntaje (10*tiempo receta).agregarMaterial (resultado receta).quitarMateriales  (materiales receta)


-- Auxiliares
tieneMateriales :: Receta -> Jugador -> Bool
tieneMateriales  receta jugador = all (tieneMaterial jugador) (materiales receta)

tieneMaterial :: Jugador -> Material -> Bool
tieneMaterial jugador material = elem material (inventario jugador)

agregarMaterial :: Material -> Jugador -> Jugador
agregarMaterial material jugador = jugador {inventario = material:inventario jugador }

quitarMateriales :: [Material] -> Jugador -> Jugador
quitarMateriales materiales jugador = jugador{inventario = foldr quitarUnaVez (inventario jugador) materiales}

quitarUnaVez:: Eq a => a -> [a] -> [a]
quitarUnaVez _ [] = []
quitarUnaVez material (m:ms)  
 | material == m = ms
 | otherwise = m:quitarUnaVez material ms 

alterarPuntaje :: Int -> Jugador ->  Jugador
alterarPuntaje n jugador  = jugador {puntaje = puntaje jugador + n}

duplican::[Receta]->Jugador->[Material]
duplican listaRecetas jugador = (map resultado . filter (auxDuplican jugador)) listaRecetas

auxDuplican::Jugador->Receta->Bool
auxDuplican jugador receta = puntaje (intentarCraftear receta jugador) >= 2*(puntaje jugador)

craftearSucesivamente::[Receta]->Jugador->Jugador
craftearSucesivamente lista jugador = foldl (auxFold) jugador lista

auxFold::Jugador->Receta->Jugador
auxFold jugador receta = intentarCraftear receta jugador

quedaConMasPuntos::[Receta]->Jugador->Bool
quedaConMasPuntos lista jugador = puntaje (craftearSucesivamente lista jugador) >= puntaje (craftearSucesivamente (reverse lista) jugador)

data Bioma = UnBioma{
    materialesPresentes :: [Material],
    materialNecesario :: Material
}

type Herramienta = [Material]->Material

minar :: Herramienta -> Bioma -> Jugador  -> Jugador
minar herramienta bioma jugador 
    | tieneMaterial jugador (materialNecesario bioma)  = agregarMaterial (herramienta (materialesPresentes bioma)) (alterarPuntaje 50 jugador)
    | otherwise = jugador