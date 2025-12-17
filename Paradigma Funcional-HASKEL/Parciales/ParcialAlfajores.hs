--Parte 1
data Alfajor = UnAlfajor{
    capas::[String],
    peso::Float,
    dulzorInnato::Float,
    nombre::String
}deriving Show

--a)
jorgito::Alfajor
jorgito = UnAlfajor ["DDL"] 80 8 "Jorgito"

havanna::Alfajor
havanna = UnAlfajor ["Mousse","Mousse"] 60 12 "Havanna"

capEspacio::Alfajor
capEspacio = UnAlfajor ["DDL"] 40 12 "Capitan del Espacio"

--b)
coeficienteDeDulzor::Alfajor->Float
coeficienteDeDulzor alfajor = dulzorInnato alfajor / peso alfajor

precioCapa::String->Float
precioCapa capa
    |capa == "DDL" = 12
    |capa == "Mousse" = 15
    |capa == "Fruta" = 10
    |otherwise = 0


precio::Alfajor->Float
precio alfajor = (peso alfajor * 2) + (sum.map precioCapa) (capas alfajor)

esPotable::Alfajor->Bool
esPotable alfajor = (not.null) (capas alfajor) && (capas alfajor == replicate (length (capas alfajor)) (head (capas alfajor))) && coeficienteDeDulzor alfajor >= 0.1

--Parte 2:
--a)
abaratar::Alfajor->Alfajor
abaratar alfajor = alfajor{peso=peso alfajor - 10,dulzorInnato=dulzorInnato alfajor - 7}

--b)
renombrar::String->Alfajor->Alfajor
renombrar nombreNuevo alfajor = alfajor {nombre = nombreNuevo}

--c)
agregarCapa::String->Alfajor->Alfajor
agregarCapa capaNueva alfajor = alfajor {capas = capas alfajor ++ [capaNueva]}

--d)
hacerPremium::Alfajor->Alfajor
hacerPremium alfajor
    | esPotable alfajor = (renombrar (nombre alfajor ++ " Premium") . agregarCapa (head (capas alfajor))) alfajor
    | otherwise = alfajor

--e)
premiumGrado::Float->Alfajor->Alfajor
premiumGrado 0 alfajor = alfajor
premiumGrado n alfajor = premiumGrado (n-1) (hacerPremium alfajor)

jorgitito::Alfajor
jorgitito = (abaratar . renombrar "Jorgitito") jorgito

jorgelin::Alfajor
jorgelin = (agregarCapa "DDL" . renombrar "Jorgelin") jorgito

capCostaAcosta::Alfajor
capCostaAcosta = (renombrar"Capitán del espacio de costa a costa" . premiumGrado 4 . abaratar) capEspacio

--Parte 3:
data Persona = UnaPersona{
    dinero::Float,
    alfajoresComprados::[Alfajor],
    criterio::(Alfajor->Bool)
}


emi= UnaPersona 120 [] aEmiLeGusta

tomi= UnaPersona 100 [] aTomiLeGusta

dante= UnaPersona 200 [] aDanteLeGusta

juan= UnaPersona 500 [] aJuanLeGusta

buscaMarca::String->Alfajor->Bool
buscaMarca nombreAlf alfajor = isInfixOf nombreAlf (nombre alfajor)

aEmiLeGusta::Alfajor->Bool
aEmiLeGusta alfajor = buscaMarca "Capitan del Espacio" alfajor

clientePretencioso::Alfajor->Bool
clientePretencioso alfajor = elem (nombre alfajor) ["Premium"]

clienteDulcero::Alfajor->Bool
clienteDulcero alfajor = coeficienteDeDulzor alfajor >= 0.15

aTomiLeGusta::Alfajor->Bool
aTomiLeGusta alfajor = clientePretencioso alfajor && clienteDulcero alfajor

esAntiCapa::String->Alfajor->Bool
esAntiCapa capa alfajor = not(elem capa (capas alfajor))

esExtranio::Alfajor->Bool
esExtranio alfajor = not (esPotable alfajor)

aDanteLeGusta::Alfajor->Bool
aDanteLeGusta alfajor = esAntiCapa "DDL" alfajor && esExtranio alfajor

aJuanLeGusta::Alfajor->Bool
aJuanLeGusta alfajor = clienteDulcero alfajor && buscaMarca "Jorgito" alfajor && clientePretencioso alfajor && esAntiCapa "Mousse" alfajor

leGustan::[Alfajor]->Persona->[Alfajor]
leGustan alfajores cliente = filter (criterio cliente) alfajores

comprarAlfajor::Persona->Alfajor->Persona
comprarAlfajor cliente alfajor
    | dinero cliente >= precio alfajor = cliente{dinero=dinero cliente-precio alfajor,alfajoresComprados=alfajoresComprados cliente ++ [alfajor]}
    | otherwise = cliente

comprarTodos::Persona->[Alfajor]->Persona
comprarTodos cliente listaAlfajores = foldl (comprarAlfajor) cliente listaAlfajores




