
% Ejemplo:
% ?- oracion(Significado, [yo, amo, las, matematicas], []).
% Significado = gusta(matematicas).

% Oración principal


oracion(Significado) -->
    sintagma_nominal,
    sintagma_verbal(Significado).

oracion(Significado) -->
    sintagma_verbal(Significado).


% Sintagma nominal


sintagma_nominal --> [yo].
sintagma_nominal --> [me].
sintagma_nominal --> [a, mi].
sintagma_nominal --> [].


% Sintagma verbal positivo


sintagma_verbal(gusta(Tema)) -->
    verbo_positivo,
    objeto(Tema).

sintagma_verbal(gusta(Tema)) -->
    [soy],
    fortaleza(Tema).


% Sintagma verbal negativo


sintagma_verbal(no_gusta(Tema)) -->
    verbo_negativo,
    objeto(Tema).

sintagma_verbal(no_gusta(Tema)) -->
    negacion,
    verbo_positivo,
    objeto(Tema).


% Verbos positivos


verbo_positivo --> [gusta].
verbo_positivo --> [gustan].
verbo_positivo --> [amo].
verbo_positivo --> [encanta].
verbo_positivo --> [disfruto].


% Verbos negativos


verbo_negativo --> [odio].
verbo_negativo --> [detesto].
verbo_negativo --> [rechazo].


% Negaciones


negacion --> [no].
negacion --> [nunca].
negacion --> [no, me].


% temas


objeto(matematicas) --> articulo, [matematicas].
objeto(tecnologia) --> articulo, [tecnologia].
objeto(personas) --> articulo, [personas].
objeto(resolver_problemas) --> [resolver, problemas].
objeto(resolver_problemas) --> [resolver, los, problemas].
objeto(escuchar) --> [escuchar].
objeto(ayudar) --> [ayudar].
objeto(arte) --> articulo, [arte].
objeto(negocios) --> articulo, [negocios].
objeto(biologia) --> articulo, [biologia].


% Fortalezas


fortaleza(tecnologia) --> [habil, con], articulo, [tecnologia].
fortaleza(matematicas) --> [bueno, en], articulo, [matematicas].
fortaleza(escuchar) --> [bueno, escuchando].
fortaleza(ayudar) --> [bueno, ayudando].
fortaleza(logica) --> [bueno, en], articulo, [logica].


% Artículos 


articulo --> [la].
articulo --> [las].
articulo --> [el].
articulo --> [los].
articulo --> [].