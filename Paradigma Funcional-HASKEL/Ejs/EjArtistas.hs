--Datos Dados
type Cancion = String
data Artista = UnArtista {
    nombre :: String,
    canciones :: [Cancion]
} deriving Show

fitito :: Artista
fitito = UnArtista "Fitito Paez" ["11 y 6", "El amor despues del amor", "Mariposa Tecknicolor"]

calamardo :: Artista
calamardo = UnArtista "Andres Calamardo" ["Flaca", "Sin Documentos", "Tuyo siempre"]

paty :: Artista
paty = UnArtista "Taylor Paty" ["Shake It Off", "Lover"]

--Punto 1:
minuscula :: Char -> Bool
minuscula letra = elem letra ['a'..'z'] 

calificacionCancion :: Cancion -> Int
calificacionCancion cancion = length (filter minuscula cancion) + 10

--Punto 2:
artistaExitoso :: Artista -> Bool
artistaExitoso = (> 50) . sum . map calificacionCancion . canciones
--artistaExitoso artista = sum (map calificacionCancion (canciones artista)) > 50

--Punto 3:
obtenerExitosos :: [Artista] -> [Artista]
obtenerExitosos = filter artistaExitoso --Pasando la lista por aplicacion parcial

--Punto 4:
hacerTodo :: [Artista] -> [Artista]
hacerTodo = filter (\artista -> sum (map (\cancion -> length (filter (\letra -> elem letra ['a'..'z']) cancion) + 10) (canciones artista)) > 50)

