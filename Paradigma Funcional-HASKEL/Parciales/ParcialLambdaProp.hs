type Barrio = String
type Mail = String
type Requisito = Depto->Bool
type Busqueda = [Requisito]

data Depto = UnDepto{
    ambientes::Int,
    superficie::Int,
    precio::Int,
    barrio::Barrio
}deriving Show

data Persona = UnaPersona{
    mail::Mail,
    busquedas::[Busqueda]
}

ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) = (ordenarSegun criterio . filter (not . criterio x)) xs ++ [x] ++ (ordenarSegun criterio . filter (criterio x)) xs


between cotaInferior cotaSuperior valor = valor <= cotaSuperior && valor >= cotaInferior

deptosDeEjemplo = [
    UnDepto 3 80 7500 "Palermo",
    UnDepto 1 45 3500 "Villa Urquiza",
    UnDepto 2 50 5000 "Palermo",
    UnDepto 1 45 5500 "Recoleta"]

--Punto 1:
mayorSegun f a b = f a > f b
menorSegun f a b = f a < f b

--B)
-- ordenarSegun (mayorSegun length) listaStrings

--Punto 2:
ubicadoEn::Depto->[Barrio]->Bool
ubicadoEn depto listaBarrios =  not (null((filter (== (barrio depto)) listaBarrios)))

cumpleRango depto f a b = between a b (f depto)

--Punto 3:
cumpleBusqueda::Busqueda->Depto->Bool
cumpleBusqueda [] _ = True
cumpleBusqueda (req1:reqs) depto = req1 depto && cumpleBusqueda reqs depto

buscar::[Depto]->Busqueda->(Depto->Depto->Bool)->[Depto]
buscar listaDeptos busqueda condicion = ordenarSegun condicion (filter (cumpleBusqueda busqueda) listaDeptos)

--Punto 4:
--mailsDePersonasInteresadas :: Depto -> [Persona] -> [Mail]
--mailsDePersonasInteresadas depto personas = map mail (filter (\persona -> any (\busqueda -> cumpleBusqueda busqueda depto) (busquedas persona)) personas)

--mailsDePersonasInteresadas :: Depto -> [Persona] -> [Mail]
--mailsDePersonasInteresadas dpto = map mail . filter (any (cumpleBusqueda dpto) . busquedas)
