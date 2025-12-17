-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart::Jugador
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd::Jugador
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa::Jugador
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


type Palo = Habilidad -> Tiro
-- I) El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.
putter :: Palo
putter habilidad = UnTiro {velocidad = 10,precision = precisionJugador habilidad * 2,altura = 0}

--II) La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.
madera :: Palo
madera habilidad = UnTiro {velocidad=100,precision = div (precisionJugador habilidad) 2, altura=5}

--III) Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión dividida por n y una altura de n-3 (con mínimo 0).
hierros :: Int->Palo
hierros n habilidad = UnTiro{velocidad=(fuerzaJugador habilidad)*n,precision= div (precisionJugador habilidad) n,altura = max (n-3) 0}

palos::[Palo]
palos=[putter,madera,hierros 1,hierros 2,hierros 3,hierros 4,hierros 5,hierros 6,hierros 7,hierros 8,hierros 9,hierros 10]

--2)
golpe::Jugador->Palo->Tiro
golpe pj palo = palo (habilidad pj)

--3)

data Obstaculo = UnObstaculo{
    loSupera::Bool,
    tiroPost::Tiro
}

superaTunel::Tiro->Obstaculo
superaTunel tiro
    | precision tiro > 90 = UnObstaculo {loSupera=True, tiroPost= UnTiro{velocidad = (velocidad tiro) * 2,precision=100,altura=0}}
    | otherwise = UnObstaculo {loSupera=False, tiroPost= UnTiro{velocidad=0,precision=0,altura=0}}

superaLaguna::Int->Tiro->Obstaculo
superaLaguna largo tiro
    | velocidad tiro > 80 && altura tiro <= 5 && altura tiro >=1 = UnObstaculo {loSupera=True, tiroPost= tiro{altura=div (altura tiro) largo}}
    | otherwise = UnObstaculo {loSupera=False, tiroPost= UnTiro{velocidad=0,precision=0,altura=0}}

superaHoyo::Tiro->Obstaculo
superaHoyo tiro
    | velocidad tiro >=5 && velocidad tiro <=20 && precision tiro >95 = UnObstaculo {loSupera=True, tiroPost=UnTiro{velocidad=0,precision=0,altura=0}}
    | otherwise = UnObstaculo {loSupera=False, tiroPost= UnTiro{velocidad=0,precision=0,altura=0}}

--4)
{-
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles persona obstaculo = filter (superaObstaculoConEsePalo persona obstaculo) palos

superaObstaculoConEsePalo :: Jugador -> Obstaculo -> Palo -> Bool
superaObstaculoConEsePalo persona obstaculo palo = superaObstaculo obstaculo (golpe persona palo) 

...
-}


--5)
padresQuePerdieron :: [(Jugador,Puntos)] -> [String]
padresQuePerdieron lista = ((map (padre.fst)).niniosPerdedores) lista

niniosPerdedores :: [(Jugador,Puntos)] -> [(Jugador,Puntos)]
niniosPerdedores lista = filter (((/= ninioGanador lista).fst)) lista

ninioGanador :: [(Jugador,Puntos)] -> Jugador
ninioGanador lista = fst (maximoSegun snd lista)
