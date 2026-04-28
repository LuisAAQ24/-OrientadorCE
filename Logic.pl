% Permite guardar datos durante la ejecución
:- dynamic gusta/1.
:- dynamic no_gusta/1.
:- dynamic candidata/1.

% Carga las bases externas
:- consult('BD.pl').
:- consult('BNF.pl').


% Inicia el programa
iniciar :-
    limpiar_datos,
    inicializar_candidatas,
    write('Hola! Dime que te gusta'), nl,
    leer_entrada(Entrada),
    procesar(Entrada),
    loop.


% Lee el texto y lo convierte en lista de palabras
leer_entrada(ListaPalabras) :-
    read_line_to_string(user_input, Texto),
    string_lower(Texto, TextoMinuscula),
    split_string(TextoMinuscula, " ", "¿?¡!.,", PalabrasString),
    maplist(atom_string, ListaPalabras, PalabrasString).


% Interpreta lo que escribe el usuario
procesar(Entrada) :-
    parsear(Entrada, Resultado),
    guardar(Resultado).

% Si no entiende
procesar(_) :-
    write('No entendi, puedes repetir?'), nl.


% Guarda lo que le gusta
guardar(gusta(Tema)) :-
    gusta(Tema).

guardar(gusta(Tema)) :-
    assertz(gusta(Tema)),
    write('Te gusta '), write(Tema), nl.

% Guarda lo que no le gusta
guardar(no_gusta(Tema)) :-
    no_gusta(Tema).

guardar(no_gusta(Tema)) :-
    assertz(no_gusta(Tema)),
    write('No te gusta '), write(Tema), nl.


% Carga todas las carreras como candidatas
inicializar_candidatas :-
    retractall(candidata(_)),
    forall(profesion(Carrera, _, _, _),
           assertz(candidata(Carrera))).


% Elimina carreras según preferencias

% Si le gusta algo que es defecto → eliminar
filtrar :-
    candidata(Carrera),
    profesion(Carrera, _, _, Defectos),
    member(Tema, Defectos),
    gusta(Tema),
    retract(candidata(Carrera)),
    fail.

% Si no le gusta algo necesario → eliminar
filtrar :-
    candidata(Carrera),
    profesion(Carrera, Afinidades, _, _),
    member(Tema, Afinidades),
    no_gusta(Tema),
    retract(candidata(Carrera)),
    fail.

% Fin del filtrado
filtrar.


% Busca temas importantes de las carreras
tema_relevante(Tema) :-
    candidata(Carrera),
    profesion(Carrera, Afinidades, _, _),
    member(Tema, Afinidades).


% Hace preguntas si falta información
preguntar_dinamico :-
    tema_relevante(Tema),
    \+ gusta(Tema),
    \+ no_gusta(Tema),
    write('Te gusta '), write(Tema), write('?'), nl,
    leer_entrada(Entrada),
    procesar(Entrada),
    !.

% Si no hay preguntas
preguntar_dinamico.


% Cuenta cuántas carreras quedan
contar_candidatas(Cantidad) :-
    findall(C, candidata(C), Lista),
    length(Lista, Cantidad).


% Muestra resultados
mostrar_resultado :-
    findall(C, candidata(C), Lista),
    Lista \= [],
    write('Te recomiendo:'), nl,
    mostrar_lista(Lista).

% Si no hay opciones
mostrar_resultado :-
    write('No encontre una carrera adecuada'), nl.


% Imprime la lista
mostrar_lista([]).
mostrar_lista([Carrera|Resto]) :-
    write('- '), write(Carrera), nl,
    mostrar_lista(Resto).


% Borra toda la memoria
limpiar_datos :-
    retractall(gusta(_)),
    retractall(no_gusta(_)),
    retractall(candidata(_)).


% Ciclo principal
loop :-
    filtrar,
    contar_candidatas(Cantidad),
    decidir(Cantidad).


% Decide si termina o sigue preguntando
decidir(Cantidad) :-
    Cantidad =< 1,
    mostrar_resultado.

decidir(Cantidad) :-
    Cantidad > 1,
    preguntar_dinamico,
    loop.