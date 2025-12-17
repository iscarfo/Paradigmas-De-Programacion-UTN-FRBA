--Sueldo por cargo:
basico :: String->Float
basico cargo
    | cargo == "Titular" = 149000
    | cargo == "Adjunto" = 116000
    | cargo == "Ayudante" = 66000
    | otherwise = 0

--Porcentaje por anios de antiguedad:
antiguedad :: Float->Float
antiguedad anios
    | anios >= 3 && anios < 5 = 20
    | anios >= 5 && anios < 10 = 30
    | anios >= 10 && anios < 24 = 50
    | anios >= 24 = 120
    | otherwise = 0

--Bonificacion por cantidad de horas:
cantHoras :: Float->Float
cantHoras horas
    | horas > 5 && horas < 15 = 1
    | horas >= 15 && horas < 25 = 2
    | horas >= 25 && horas < 35 = 3
    | horas >= 35 && horas < 45 = 4
    | horas >= 45 = 5
    | otherwise = 0

--Funcion para el sueldo total:
sueldoUTN :: String->Float->Float->Float
sueldoUTN cargo anios horas = (basico cargo + ((basico cargo*antiguedad anios) / 100)) * cantHoras horas

canastaBasica :: Float -> Float
canastaBasica x
    | x == 1 = 126000
    | x == 3 = 310000
    | x == 4 = 390000
    | x == 5 = 410000

--Noviembre:
--llegarAfinDeMes :: Float -> String -> Float -> Float -> Float
--llegarAfinDeMes familia cargo anios horas = sueldoUTN cargo anios horas - canastaBasica familia 

conseguirSueldo :: String->Float->Float->Float-> Float
conseguirSueldo cargo anios horas aumento = sueldoUTN cargo anios horas + ((sueldoUTN cargo anios horas*aumento)/100)

conseguirCanasta :: Float -> Float ->Float
conseguirCanasta personas inflacion = canastaBasica personas + ((canastaBasica personas*inflacion)/100)

--Febrero:
llegarAfinDeMes :: Float -> String -> Float -> Float -> Float -> Float -> Float
llegarAfinDeMes familia cargo anios horas aumento inflacion = conseguirSueldo cargo anios horas aumento - conseguirCanasta familia inflacion



