--Prueba de Comandos:
doble,tripl :: Float->Float
doble x = x+x
tripl x = x*3

esCero::Int->Bool 
esCero 0=True
esCero x=False

sueldos :: Float->Float
sueldos 0 = 0
sueldos x = x-(x*0.21)

--GUIA DE EJS
--EJ 1: Definir la función esMultiploDeTres/1, que devuelve True si un número es múltiplo de 3
esMultiploDeTres :: Int->Bool
esMultiploDeTres x = mod x 3==0

--EJ 2: Definir la función esMultiploDe/2, que devuelve True si el segundo es múltiplo del primero
esMultiploDe :: Int->Int->Bool
esMultiploDe x y = mod x y==0

--EJ 3: Definir la función cubo/1, devuelve el cubo de un número
cubo :: Int->Int
cubo x = x*x*x

--EJ 4: Definir la función area/2, devuelve el área de un rectángulo a partir de su base y su altura
areaRec :: Int->Int->Int
areaRec b h = b*h

--EJ 5: Definir la función esBisiesto/1, indica si un año es bisiesto. 
--(Un año es bisiesto si es divisible por 400 o es divisible por 4 pero no es divisible por 100)
esBisiesto :: Int->Bool
esBisiesto x = esMultiploDe x 400 || esMultiploDe x 4 && not (esMultiploDe x 100)

--EJ 6:Definir la función celsiusToFahr/1, pasa una temperatura en grados Celsius a grados Fahrenheit.
celsiusToFahr :: Float->Float
celsiusToFahr x = 32 + (1.8 * x)

--EJ 7:Definir la función fahrToCelsius/1, la inversa de la anterior
fahrToCelsius :: Float->Float
fahrToCelsius x = (x - 32)*(5/9)

--EJ 8:Definir la función haceFrioF/1, indica si una temperatura expresada en grados Fahrenheit es fría. 
--Decimos que hace frío si la temperatura es menor a 8 grados Celsius. 
haceFrio :: Float->Bool
haceFrio x = fahrToCelsius x <= 8

--EJ 9:Definir la función mcm/2 que devuelva el mínimo común múltiplo entre dos números, 
--de acuerdo a esta fórmula: m.c.m.(a, b) = {a * b} / {m.c.d.(a, b)} 
mcm :: Int->Int->Int
mcm x y = div (x*y) (gcd x y)

{-EJ 10:Trabajamos con tres números que imaginamos como el nivel del río Paraná a la altura de 
Corrientes medido en tres días consecutivos; cada medición es un entero que representa una 
cantidad de cm. P.ej. medí los días 1, 2 y 3, las mediciones son: 322 cm, 283 cm, y 294 cm. 
A partir de estos tres números, podemos obtener algunas conclusiones. 
Definir estas funciones: 

dispersion, que toma los tres valores y devuelve la diferencia entre el más alto y el más bajo. 
Ayuda: extender max y min a tres argumentos, usando las versiones de dos elementos. 
De esa forma se puede definir dispersión sin escribir ninguna guarda 
(las guardas están en max y min, que estamos usando). 

diasParejos, diasLocos y diasNormales reciben los valores de los tres días. 
Se dice que son días parejos si la dispersión es chica, que son días locos si la dispersión es grande, 
y que son días normales si no son ni parejos ni locos. 
Una dispersión se considera chica si es de menos de 30 cm, y grande si es de más de un metro. 
Nota: Definir diasNormales a partir de las otras dos, no volver a hacer las cuentas
-}
--PUNTO A:
maxTres :: Int->Int->Int->Int
maxTres a b c 
    | max a b == a && max a c == a = a
    | max a b == b && max b c == b = b
    | otherwise = c

minTres :: Int->Int->Int->Int
minTres a b c 
    | min a b == a && min a c == a = a
    | min a b == b && min b c == b = b
    | otherwise = c

dispersion :: Int->Int->Int->Int
dispersion x y z = maxTres x y z - minTres x y z

--PUNTO B:
diasParejos :: Int->Int->Int->Bool
diasParejos x y z = dispersion x y z < 30

diasLocos :: Int->Int->Int->Bool
diasLocos x y z = dispersion x y z > 100

diasNormales :: Int->Int->Int->Bool
diasNormales x y z = not (diasParejos x y z) && not (diasLocos x y z)

{-EJ 11: En una plantación de pinos, de cada árbol se conoce la altura expresada en cm. 
El peso de un pino se puede calcular a partir de la altura así: 3 kg x cm hasta 3 metros, 
2 kg x cm arriba de los 3 metros. P.ej. 2 metros ⇒  600 kg, 5 metros ⇒  1300 kg. 
Los pinos se usan para llevarlos a una fábrica de muebles, 
a la que le sirven árboles de entre 400 y 1000 kilos, 
un pino fuera de este rango no le sirve a la fábrica. Para esta situación: 
Definir la función pesoPino, recibe la altura de un pino y devuelve su peso. 
Definir la función esPesoUtil, recibe un peso en kg 
y devuelve True si un pino de ese peso le sirve a la fábrica, y False en caso contrario. 
Definir la función sirvePino, recibe la altura de un pino 
y devuelve True si un pino de ese peso le sirve a la fábrica, y False en caso contrario. 
Usar composición en la definición.-}

--Primeras Funciones
pesoPrimerosTres :: Int->Int
pesoPrimerosTres x = min x 3 * 300

pesoRestantes :: Int->Int
pesoRestantes x = max 0 (x-3) * 200

pesoPino :: Int->Int
pesoPino x = pesoPrimerosTres x + pesoRestantes x

--Punto 2:
esPesoUtil :: Int->Bool
esPesoUtil x = x >= 400 && x <= 1000

--Punto 3:
sirvePino :: Int->Bool
sirvePino x = esPesoUtil (pesoPino x)


--Ejercicio ACME
cantEmpleados :: String->Int
cantEmpleados "ACME" = 10
cantEmpleados x
    | last x < head x = length x - 2
    | (x == reverse x) && even (length x) = (length x -2)*2
    | mod (length x) 3 == 0 || mod (length x) 7 == 0 = 3
    | otherwise = 0

--EJS Adicionales:

cantDiasAnio :: Int->Int
cantDiasAnio anio
    | esBisiesto anio = 366
    | otherwise = 365

fact :: Int->Int
fact 0 = 1
fact x = x * fact (x-1)













