:- dynamic gusta/1.
:- dynamic no_gusta/1.
:- dynamic candidata/1.

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



inicializar_candidatas :-
    retractall(candidata(_)),
    forall(profesion(C, _, _, _), assertz(candidata(C))).


filtrar :-
    forall(
        candidata(C),
        (
            profesion(C, Afinidades, _, Defectos),
            (
                (member(X, Defectos), gusta(X)) ;
                (member(X, Afinidades), no_gusta(X))
            )
            ->
                retract(candidata(C))
            ;
                true
        )
    ).


tema_relevante(Tema) :-
    candidata(C),
    profesion(C, Afinidades, _, _),
    member(Tema, Afinidades).


preguntar_dinamico :-
    tema_relevante(Tema),
    \+ gusta(Tema),
    \+ no_gusta(Tema),
    write('Te gusta '), write(Tema), write('?'), nl,
    leer_entrada(Input),
    procesar(Input),
    !.

preguntar_dinamico.


contar_candidatas(N) :-
    findall(C, candidata(C), Lista),
    length(Lista, N).


mostrar_resultado :-
    findall(C, candidata(C), Lista),
    Lista \= [],
    write('Dadas tus preferencias te recomiendo:'), nl,
    mostrar_lista(Lista), !.

mostrar_resultado :-
    write('No encontre una carrera adecuada con tus respuestas.'), nl.

mostrar_lista([]).
mostrar_lista([H|T]) :-
    write('- '), write(H), nl,
    mostrar_lista(T).


limpiar_datos :-
    retractall(gusta(_)),
    retractall(no_gusta(_)),
    retractall(candidata(_)).


loop :-
    filtrar,
    contar_candidatas(N),
    (
        N =< 1 ->
            mostrar_resultado
        ;
            preguntar_dinamico,
            loop
    ).


iniciar :-
    limpiar_datos,
    inicializar_candidatas,
    write('Hola! Dime que te gusta'), nl,
    leer_entrada(Input),
    procesar(Input),
    loop.