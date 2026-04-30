

%Vocabulario
% Lista de palabras reconocidas
% Para agregar una palabra nueva, solo hay que agregar un hecho en la categoría

 
 
% Pronombres
pronombre(yo).
pronombre(me).
pronombre(mi).
 
% Negaciones

negacion_palabra(no).
negacion_palabra(jamas).
negacion_palabra(nunca).
 
 

 
% Predicado principal
% Recibe la lista de palabras 
% devuelve gusta(Tema) o no_gusta(Tema).
parsear(ListaPalabras, Significado) :-
    phrase(oracion(Significado), ListaPalabras).
 
% Oracion

% Forma 1: sujeto + verbo + predicado
oracion(Significado) -->
    sintagma_nominal,
    sintagma_verbal(Significado).
 
% Forma 2: Sin sujeto
oracion(Significado) -->
    sintagma_verbal(Significado).
 
% Sintagma Nominal (Sujetos)

sintagma_nominal --> [yo].
sintagma_nominal --> [me].
sintagma_nominal --> [a, mi].
sintagma_nominal --> []. %Oración sin sujeto
 
% Sintagma Verbal Positivo
% Caso 1: Verbo positivo + objeto
sintagma_verbal(gusta(Tema)) -->
    verbo_positivo,
    objeto(Tema).
 
% Caso 2: "soy bueno/habil en..." se interpreta como afinidad positiva
sintagma_verbal(gusta(Tema)) -->
    [soy],
    fortaleza(Tema).
 
% Sintagma Verbal Negativo
% Caso 3: Verbo negativo + objeto
sintagma_verbal(no_gusta(Tema)) -->
    verbo_negativo,
    objeto(Tema).
 
% Caso 4: Negacion + verbo positivo + objeto
% El "no" invierte el sentido del verbo positivo.
sintagma_verbal(no_gusta(Tema)) -->
    negacion,
    verbo_positivo,
    objeto(Tema).
 
% Verbos Positivos
% Cuando el parser encuentra uno, el resultado sera gusta(Tema).
verbo_positivo --> [gusta].
verbo_positivo --> [gustan].
verbo_positivo --> [amo].
verbo_positivo --> [adoro].
verbo_positivo --> [encanta].
verbo_positivo --> [encantan].
verbo_positivo --> [disfruto].
verbo_positivo --> [prefiero].
verbo_positivo --> [me, gusta].
verbo_positivo --> [me, gustan].
verbo_positivo --> [me, encanta].
verbo_positivo --> [me, encantan].
verbo_positivo --> [me, interesa].
verbo_positivo --> [me, interesan].
verbo_positivo --> [me, apasiona].
verbo_positivo --> [me, fascina].
 
% Verbos Negativos
% Cuando el parser encuentra uno, el resultado sera no_gusta(Tema).
verbo_negativo --> [odio].
verbo_negativo --> [detesto].
verbo_negativo --> [rechazo].
verbo_negativo --> [aborrezco].
verbo_negativo --> [no, me, gusta].
verbo_negativo --> [no, me, gustan].
verbo_negativo --> [no, me, interesa].
verbo_negativo --> [no, soporto].
verbo_negativo --> [no, aguanto].
 
% Negaciones
%En caso de que el usuario use una negacion con un verbo positivo, se interpreta como no_gusta(Tema).
negacion --> [no].
negacion --> [nunca].
negacion --> [jamas].
negacion --> [no, me].
 
% Objeto (Tema)
% Extrae el atomo del tema que Logic.pl guardara en la base de datos.
% Debe coincidir exactamente con los temas definidos en BD.pl.

% Cada objeto tiene dos formas: con articulo y sin articulo.
% "resolver_problemas" tiene forma especial de dos palabras.
objeto(matematicas) --> articulo, [matematicas].
objeto(tecnologia) --> articulo, [tecnologia].
objeto(personas) --> articulo, [personas].
objeto(resolver_problemas) --> [resolver, problemas].
objeto(resolver_problemas) --> [resolver, los, problemas].
objeto(escuchar) --> articulo, [escuchar].
objeto(escuchar) --> [escuchar].
objeto(ayudar) --> articulo, [ayudar].
objeto(ayudar) --> [ayudar].
objeto(arte) --> articulo, [arte].
objeto(biologia) --> articulo, [biologia].
objeto(creatividad) --> articulo, [creatividad].
objeto(leer) --> [leer].
objeto(argumentar) --> [argumentar].
objeto(liderazgo) --> articulo, [liderazgo].
objeto(liderazgo) --> [liderazgo].
objeto(construir) --> [construir].
objeto(comunicar) --> [comunicar].
objeto(naturaleza) --> articulo, [naturaleza].
objeto(investigar) --> [investigar].
objeto(organizacion) --> articulo, [organizacion].
objeto(organizacion) --> [organizacion].
 
% Fortalezas
% Se interpretan como afinidad positiva hacia ese tema.

fortaleza(tecnologia) --> [habil, con], articulo, [tecnologia].
fortaleza(matematicas) --> [bueno, en], articulo, [matematicas].
fortaleza(matematicas) --> [buena, en], articulo, [matematicas].
fortaleza(escuchar) --> [bueno, escuchando].
fortaleza(escuchar) --> [buena, escuchando].
fortaleza(ayudar) --> [bueno, ayudando].
fortaleza(ayudar) --> [buena, ayudando].
fortaleza(liderazgo) --> [buen, lider].
fortaleza(liderazgo) --> [buena, lider].
fortaleza(comunicar) --> [bueno, comunicando].
fortaleza(comunicar) --> [buena, comunicando].
 
% Articulos (Determinantes)
% El caso vacio ([]) permite oraciones sin articulo.
articulo --> [la].
articulo --> [las].
articulo --> [el].
articulo --> [los].
articulo --> [un].
articulo --> [una].
articulo --> [].