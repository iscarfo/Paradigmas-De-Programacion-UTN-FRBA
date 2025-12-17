total:: String ->Int

total palabra = length palabra

totalCaracter :: [String]->Int

totalCaracter lista = sum (map total lista)

aux :: String ->Bool

aux letras = length letras>3

masTresCaracteres :: [String] -> Int

masTresCaracteres lista = length (filter aux lista)