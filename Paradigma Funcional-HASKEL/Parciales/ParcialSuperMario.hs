data Plomero = UnPlomero{
    nombre::String,
    cajaHerramientas::[Herramienta],
    historialReparaciones::[Reparacion],
    dinero::Float
}

data Herramienta = UnaHerramienta{
    denominacion::String,
    precio::Float,
    material::String
}

--Punto 1:
mario::Plomero
mario = UnPlomero "Mario" [(UnaHerramienta "Martillo" 20 "Madera"),(UnaHerramienta "Llave Inglesa" 200 "Hierro")] [] 1200

generarLista::Herramienta->[Herramienta]
generarLista (UnaHerramienta nombre prec mater) = generarLista (UnaHerramienta nombre (prec+1) mater)

wario::Plomero
wario = UnPlomero "Wario" (generarLista (UnaHerramienta "Llave Francesa" 1 "Hierro")) [] 0.50

--Punto 2:
tieneHerramienta::String->Plomero->Bool
tieneHerramienta nombreHerramienta plomero = elem nombreHerramienta (map denominacion (cajaHerramientas plomero))

esMalvado::Plomero->Bool
esMalvado plomero = take 2 (nombre plomero) == "Wa"

puedeComprarHerramienta::Herramienta->Plomero->Bool
puedeComprarHerramienta herramienta plomero = dinero plomero >= precio herramienta

--Punto 3:
esBuena::Herramienta->Bool
esBuena herramienta = (material herramienta == "Hierro" && precio herramienta > 10000) || (denominacion herramienta == "Martillo" && (material herramienta == "Hierro" || material herramienta == "Goma"))

--Punto 4:
comprarHerramienta::Herramienta->Plomero->Plomero
comprarHerramienta herramienta plomero
    | puedeComprarHerramienta herramienta plomero = plomero{dinero=dinero plomero-precio herramienta,cajaHerramientas=cajaHerramientas plomero ++ [herramienta]}
    | otherwise = plomero

--Punto 5:
data Reparacion = UnaReparacion{
    descripcion::String,
    requerimiento::Plomero->Bool
}

--tieneLlaveInglesa::Plomero->Bool
--tieneLlaveInglesa plomero = elem "Llave Inglesa" (map (denominacion) (cajaHerramientas plomero))

filtracionAgua = UnaReparacion "Filtracion de agua" (tieneHerramienta "Llave Inglesa")

esComplicada::String->Bool
esComplicada texto = length texto > 100

esMayus::Char->Bool
esMayus letra = elem letra "A..Z"

esGrito::String->Bool
esGrito texto = all (esMayus) texto

esDificil::Reparacion->Bool
esDificil reparacion = esComplicada (descripcion reparacion) && esGrito (descripcion reparacion)

presupuesto::Reparacion->Int
presupuesto reparacion = 3 * length (descripcion reparacion)

--Punto 6:
hacerReparacion::Float->Plomero->Reparacion->Plomero
hacerReparacion presupuesto plomero reparacion
    | (requerimiento reparacion) plomero || (esMalvado plomero && tieneHerramienta "Martillo" plomero) = situaciones presupuesto plomero reparacion
    | otherwise = plomero{dinero=dinero plomero + 100}

situaciones::Float->Plomero->Reparacion->Plomero
situaciones presupuesto plomero reparacion
    | esMalvado plomero = plomero{cajaHerramientas=cajaHerramientas plomero++[(UnaHerramienta "Destornillador" 0 "Plastico")],dinero=dinero plomero + presupuesto,historialReparaciones=historialReparaciones plomero++[reparacion]}
    | not (esMalvado plomero) && esDificil reparacion = plomero{cajaHerramientas=filter esBuena (cajaHerramientas plomero),dinero=dinero plomero + presupuesto,historialReparaciones=historialReparaciones plomero++[reparacion]}
    | not (esMalvado plomero) && not (esDificil reparacion) = plomero{cajaHerramientas=drop 1 (cajaHerramientas plomero),dinero=dinero plomero + presupuesto,historialReparaciones=historialReparaciones plomero++[reparacion]}
    | otherwise = plomero

--Punto 7:
jornadaTrabajo::[Reparacion]->Plomero->Plomero
jornadaTrabajo listaRep plomero = foldl (hacerReparacion 100) plomero listaRep

--Punto 8:
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

masReparador::[Plomero]->[Reparacion]->Plomero
masReparador listaPlomeros listaReparaciones = maximoSegun (length . historialReparaciones) (map (jornadaTrabajo listaReparaciones) listaPlomeros)

masAdinerado::[Plomero]->[Reparacion]->Plomero
masAdinerado listaPlomeros listaReparaciones = maximoSegun (dinero) (map (jornadaTrabajo listaReparaciones) listaPlomeros)

precioTotalHerramientas :: Plomero -> Float
precioTotalHerramientas plomero = (sum . map precio) (cajaHerramientas plomero)

masInvirtio::[Plomero]->[Reparacion]->Plomero
masInvirtio listaPlomeros listaReparaciones = maximoSegun (precioTotalHerramientas) (map (jornadaTrabajo listaReparaciones) listaPlomeros)