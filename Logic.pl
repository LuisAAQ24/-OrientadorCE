:- dynamic gusta/1.
:- dynamic no_gusta/1.

:- consult('BD.pl').
:- consult('BNF.pl').


leer_entrada(Lista) :-
    read_line_to_string(user_input, Input),
    string_lower(Input, Lower),
    split_string(Lower, " ", "¿?¡!.,", Palabras),
    maplist(atom_string, Lista, Palabras).



procesar(Input) :-
    ( parsear(Input, Resultado) ->
        guardar(Resultado)
    ;
        write('No entendi, puedes repetir?'), nl
    ).

guardar(gusta(X)) :-
    (gusta(X) -> true ; assertz(gusta(X))),
    write('Entiendo que te gusta '), write(X), nl.

guardar(no_gusta(X)) :-
    (no_gusta(X) -> true ; assertz(no_gusta(X))),
    write('Entiendo que no te gusta '), write(X), nl.


recomendar(Carrera) :-
    profesion(Carrera, Afinidades, _, Defectos),
    sigustos(Afinidades),
    nodefectos(Defectos).

sigustos([]).
sigustos([H|T]) :-
    gusta(H),
    sigustos(T).

nodefectos([]).
nodefectos([H|T]) :-
    \+ no_gusta(H),
    nodefectos(T).


iniciar :-
    limpiar_datos,
    write('Hola! Dime que te gusta'), nl,
    conversacion.

conversacion :-
    leer_entrada(Input),
    procesar(Input),

    preguntar(tecnologia, 'Te gusta la tecnologia?'),
    preguntar(personas, 'Te gustan las personas?'),
    preguntar(resolver_problemas, 'Te gusta resolver problemas?'),

    mostrar_recomendacion.


preguntar(Tema, Pregunta) :-
    (gusta(Tema) ; no_gusta(Tema)) ->
        true ;  % ya lo sabe → no pregunta
    (
        write(Pregunta), nl,
        leer_entrada(Input),
        procesar(Input)
    ).


limpiar_datos :-
    retractall(gusta(_)),
    retractall(no_gusta(_)).


mostrar_recomendacion :-
    recomendar(C),
    write('Dadas tus preferencias te recomiendo estudiar: '),
    write(C), nl, !.

mostrar_recomendacion :-
    write('No encontre una carrera exacta con tus preferencias.'), nl.