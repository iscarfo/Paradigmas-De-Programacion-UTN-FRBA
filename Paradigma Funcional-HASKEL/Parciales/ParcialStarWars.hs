--Punto 1:
data Nave = UnaNave{
    nombre::String,
    durabilidad::Int,
    escudo::Int,
    ataque::Int,
    poder::(Nave->Nave)
}

movTurbo::Nave->Nave
movTurbo nave = nave{ataque=ataque nave + 25}

tieFighter = UnaNave "TIE Fighter" 200 100 50 movTurbo

reparacionEmergencia::Nave->Nave
reparacionEmergencia nave = nave{durabilidad=durabilidad nave + 50,ataque=ataque nave-30}

xWing = UnaNave "X Wing" 300 150 100 reparacionEmergencia

movSuperTurbo::Nave->Nave
movSuperTurbo nave = (movTurbo . movTurbo . movTurbo) nave {durabilidad=durabilidad nave-45}

naveDV= UnaNave "Nave Darth Vader" 500 300 200 movSuperTurbo

poderMilFalcon::Nave->Nave
poderMilFalcon nave = reparacionEmergencia nave {escudo=escudo nave+100}

milFalcon = UnaNave "Millennium Falcon" 1000 500 50 poderMilFalcon

poderEstrellaDeLaMuerte::Nave->Nave
poderEstrellaDeLaMuerte nave = (movSuperTurbo . reparacionEmergencia) nave

estrellaM = UnaNave "Estrella De La Muerte" 100000 50000 1000 poderEstrellaDeLaMuerte

--Punto 2:
durabilidadFlota::[Nave]->Int
durabilidadFlota listaNaves = (sum . map durabilidad) listaNaves

--Punto 3:

verSiEsMayor::Int->Int->Int
verSiEsMayor a b
    | a > b = a-b
    | otherwise = 0

ataqueEntreNaves::Nave->Nave->Nave
ataqueEntreNaves naveQueAtaca naveAtacada = naveAtacada {durabilidad = max 0 (durabilidad (poder naveAtacada naveAtacada)  + verSiEsMayor (ataque (poder naveQueAtaca naveQueAtaca)) (escudo (poder naveAtacada naveAtacada)))}

--Punto 4:
naveFueraCombate::Nave->Bool
naveFueraCombate nave = durabilidad nave == 0

--Punto 5:
navesDebiles::Nave->Bool
navesDebiles nave = escudo nave < 200

navesPeligrosas::Int->Nave->Bool
navesPeligrosas n nave = ataque nave > n

navesFueraDeCombate::Nave->Nave->Bool
navesFueraDeCombate naveQueAtaca naveAtacada = naveFueraCombate (ataqueEntreNaves naveQueAtaca naveAtacada)

navesCortas::Nave->Bool
navesCortas nave = durabilidad nave < 50

misionSorpresa::Nave->[Nave]->(Nave->Bool)->[Nave]
misionSorpresa naveQueAtaca flotaEnemiga condicion = (map (ataqueEntreNaves naveQueAtaca)  . filter condicion) flotaEnemiga

--Punto 6:
misionEquis::Nave->[Nave]->(Nave->Bool)->(Nave->Bool)->[Nave]
misionEquis naveQueAtaca flotaEnemiga con1 con2
    | durabilidadFlota (misionSorpresa naveQueAtaca flotaEnemiga con1) > durabilidadFlota (misionSorpresa naveQueAtaca flotaEnemiga con2) = misionSorpresa naveQueAtaca flotaEnemiga con1
    | otherwise = misionSorpresa naveQueAtaca flotaEnemiga con2

--Punto 7:
flotaInfNaves::[Nave]
flotaInfNaves = cycle [xWing,tieFighter]

--No es posible determinar su durabilidad total; resultados infinitos por la evaluacion diferida