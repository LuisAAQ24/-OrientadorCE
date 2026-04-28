:- dynamic gusta/1.
:- dynamic no_gusta/1.
:- dynamic candidata/1.

:- consult('BD.pl').
:- consult('BNF.pl').



leer_entrada(ListaPalabras) :-
    read_line_to_string(user_input, Texto),
    string_lower(Texto, TextoMinuscula),
    split_string(TextoMinuscula, " ", "¿?¡!.,", PalabrasString),
    maplist(atom_string, ListaPalabras, PalabrasString).



procesar(Entrada) :-
    parsear(Entrada, Resultado),
    guardar(Resultado).

procesar(_) :-
    write('No entendi, puedes repetir?'), nl.


guardar(gusta(Tema)) :-
    gusta(Tema).

guardar(gusta(Tema)) :-
    assertz(gusta(Tema)),
    write('Entiendo que te gusta '), write(Tema), nl.

guardar(no_gusta(Tema)) :-
    no_gusta(Tema).

guardar(no_gusta(Tema)) :-
    assertz(no_gusta(Tema)),
    write('Entiendo que no te gusta '), write(Tema), nl.



inicializar_candidatas :-
    retractall(candidata(_)),
    forall(profesion(Carrera, _, _, _), assertz(candidata(Carrera))).




% Caso 1: le gusta algo que es defecto → eliminar
filtrar :-
    candidata(Carrera),
    profesion(Carrera, _, _, Defectos),
    member(Tema, Defectos),
    gusta(Tema),
    retract(candidata(Carrera)),
    fail.

% Caso 2: no le gusta algo que la carrera requiere → eliminar
filtrar :-
    candidata(Carrera),
    profesion(Carrera, Afinidades, _, _),
    member(Tema, Afinidades),
    no_gusta(Tema),
    retract(candidata(Carrera)),
    fail.

% Caso base
filtrar.


tema_relevante(Tema) :-
    candidata(Carrera),
    profesion(Carrera, Afinidades, _, _),
    member(Tema, Afinidades).



preguntar_dinamico :-
    tema_relevante(Tema),
    \+ gusta(Tema),
    \+ no_gusta(Tema),
    write('Te gusta '), write(Tema), write('?'), nl,
    leer_entrada(Entrada),
    procesar(Entrada),
    !.

preguntar_dinamico.



contar_candidatas(Cantidad) :-
    findall(C, candidata(C), Lista),
    length(Lista, Cantidad).



mostrar_resultado :-
    findall(C, candidata(C), Lista),
    Lista \= [],
    write('Dadas tus preferencias te recomiendo:'), nl,
    mostrar_lista(Lista).

mostrar_resultado :-
    write('No encontre una carrera adecuada con tus respuestas.'), nl.

mostrar_lista([]).
mostrar_lista([Carrera|Resto]) :-
    write('- '), write(Carrera), nl,
    mostrar_lista(Resto).



limpiar_datos :-
    retractall(gusta(_)),
    retractall(no_gusta(_)),
    retractall(candidata(_)).



loop :-
    filtrar,
    contar_candidatas(Cantidad),
    decidir(Cantidad).

decidir(Cantidad) :-
    Cantidad =< 1,
    mostrar_resultado.

decidir(Cantidad) :-
    Cantidad > 1,
    preguntar_dinamico,
    loop.


iniciar :-
    limpiar_datos,
    inicializar_candidatas,
    write('Hola! Dime que te gusta'), nl,
    leer_entrada(Entrada),
    procesar(Entrada),
    loop.