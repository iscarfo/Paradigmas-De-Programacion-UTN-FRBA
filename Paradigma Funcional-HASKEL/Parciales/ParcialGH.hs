data Participante = UnParticipante{
    nombre::String,
    edad::Int,
    nivelAtractivo::Int,
    nivelPersonalidad::Int,
    nivelInteligencia::Int,
    criterioPar::[Participante]->Participante
}

data Semanal = UnaPrueba{
    criterio::(Participante->Bool),
    indiceExito::Int,
    loQueHacen::Semanal->Participante->Semanal
}

baileTT::Semanal
baileTT= UnaPrueba (personalidadMayorA 20) 0 baileTikTok

baileTikTok::Semanal->Participante->Semanal
baileTikTok semanal participante
    | ((criterio semanal) participante) = cambiarIndiceTT semanal participante
    | otherwise = semanal{indiceExito=0}

personalidadMayorA::Int->Participante->Bool
personalidadMayorA n participante = nivelPersonalidad participante >= n

cambiarIndiceTT::Semanal->Participante->Semanal
cambiarIndiceTT prueba participante = prueba{indiceExito=nivelPersonalidad participante + 2* nivelAtractivo participante}

botRojo::Semanal
botRojo= UnaPrueba (\p->personalidadMayorA 10 p && inteligenciaMayorA 20 p) 0 botonRojo

botonRojo::Semanal->Participante->Semanal
botonRojo semanal participante
    | ((criterio semanal) participante) = cambiarIndiceBR semanal participante
    | otherwise = semanal{indiceExito=0}

inteligenciaMayorA::Int->Participante->Bool
inteligenciaMayorA n participante = nivelInteligencia participante >= n

cambiarIndiceBR::Semanal->Participante->Semanal
cambiarIndiceBR prueba participante = prueba{indiceExito=nivelPersonalidad participante + 2* nivelAtractivo participante}

quienesSuperan::[Participante]->Semanal->[Participante]
quienesSuperan lista semanal = filter (not.(criterio semanal)) lista

promIndice::[Participante]->Semanal->Int
promIndice lista semanal = div (sum(map indiceExito (map ((loQueHacen semanal) semanal) lista))) (length lista)

esFav::Participante->Semanal->Bool
esFav participante semanal = indiceExito ((loQueHacen semanal) semanal participante) >= 50

esFavEnTodas::Participante->[Semanal]->Bool
esFavEnTodas participante listaSemanal = all (esFav participante) listaSemanal

maximoSegun::(a->Int)->[a]->a
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun::(a->Int)->a->a->a
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

minimoSegun::(a->Int)->[a]->a
minimoSegun f = foldl1 (menorSegun f)
menorSegun::(a->Int)->a->a->a
menorSegun f a b
  | f a < f b = a
  | otherwise = b

menosInteligente::[Participante]->Participante
menosInteligente lista = minimoSegun (nivelInteligencia) lista

masAtractivo::[Participante]->Participante
masAtractivo lista = maximoSegun (nivelAtractivo) lista

masViejo::[Participante]->Participante
masViejo lista = maximoSegun (edad) lista

listaParticipantes::[Participante]
listaParticipantes = [javierTulei,minimoKirchner,horacioBerreta,myriamBergwoman]

javierTulei::Participante
javierTulei = UnParticipante "Javier Tulei" 52 30 70 35 menosInteligente

minimoKirchner::Participante
minimoKirchner = UnParticipante "Mínimo Kirchner" 46 0 40 50 masAtractivo

horacioBerreta::Participante
horacioBerreta = UnParticipante "Horacio Berreta" 57 10 60 50 masAtractivo

myriamBergwoman::Participante
myriamBergwoman = UnParticipante "Myriam Bregwoman" 51 40 40 60 masViejo

votar::[Participante]->[Participante]
votar lista = map (\p->(criterioPar p) lista) lista

estaAlHorno::Participante->[Participante]->Bool
estaAlHorno participante lista = cuentaVotos participante lista >= 3

cuentaVotos::Participante->[Participante]->Int
cuentaVotos participante lista = (length .filter (== nombre participante)) (map nombre lista)

hayAlgoPersonal::Participante->[Participante]->Bool
hayAlgoPersonal participante lista = all (== nombre participante) (map nombre lista)

zafo::Participante->[Participante]->Bool
zafo participante lista = not (any (== nombre participante) (map nombre lista))


