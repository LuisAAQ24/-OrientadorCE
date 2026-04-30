% permite guardar datos durante la ejecución
:- dynamic gusta/1.
:- dynamic no_gusta/1.
:- dynamic candidata/1.

% carga las bases externas
:- consult('BD.pl').
:- consult('BNF.pl').


% inicia el programa
iniciar :-
    limpiar_datos,
    inicializar_candidatas,
    write('Hola! Dime que te gusta'), nl,
    leer_entrada(Entrada),
    procesar(Entrada),
    loop.


% lee el texto y lo convierte en lista de palabras
leer_entrada(ListaPalabras) :-
    read_line_to_string(user_input, Texto),
    string_lower(Texto, TextoMinuscula),
    split_string(TextoMinuscula, " ", "¿?¡!.,", PalabrasString),
    maplist(atom_string, ListaPalabras, PalabrasString).


% interpreta lo que escribe el usuario
procesar(Entrada) :-
    parsear(Entrada, Resultado),
    guardar(Resultado).

% si no entiende
procesar(_) :-
    write('No entendi, puedes repetir?'), nl.


% guarda lo que le gusta
guardar(gusta(Tema)) :-
    gusta(Tema).

guardar(gusta(Tema)) :-
    assertz(gusta(Tema)),
    write('Te gusta '), write(Tema), nl.

% guarda lo que no le gusta
guardar(no_gusta(Tema)) :-
    no_gusta(Tema).

guardar(no_gusta(Tema)) :-
    assertz(no_gusta(Tema)),% Agrega el hecho a la base de datos dinámica
    write('No te gusta '), write(Tema), nl.


% carga todas las carreras como candidatas
inicializar_candidatas :-
    retractall(candidata(_)),
    forall(profesion(Carrera, _, _, _), %No se fija en detalles
           assertz(candidata(Carrera))).


% elimina carreras según preferencias

% si le gusta algo que es defecto eliminar
filtrar :-
    candidata(Carrera),
    profesion(Carrera, _, _, Defectos), %No se fija en afinidades ni habilidades
    member(Tema, Defectos),
    gusta(Tema),
    retract(candidata(Carrera)),
    fail.

% si no le gusta algo necesario eliminar
filtrar :-
    candidata(Carrera),
    profesion(Carrera, Afinidades, _, _), %No se fija en defectos ni habilidades
    member(Tema, Afinidades),
    no_gusta(Tema),
    retract(candidata(Carrera)),
    fail.

% fin del filtrado
filtrar.


% busca temas importantes de las carreras
tema_relevante(Tema) :-
    candidata(Carrera),
    profesion(Carrera, Afinidades, _, _),
    member(Tema, Afinidades).


% verifica si aun quedan temas relevantes que no se han preguntado
% es decir, existe un tema que no esta ni en gusta ni en no_gusta
hay_preguntas_pendientes :-
    tema_relevante(Tema),
    \+ gusta(Tema),
    \+ no_gusta(Tema).


% hace preguntas si falta información
preguntar_dinamico :-
    tema_relevante(Tema),
    \+ gusta(Tema), % Si no se sabe que le gusta, preguntar
    \+ no_gusta(Tema),
    write('Te gusta '), write(Tema), write('?'), nl,
    leer_entrada(Entrada),
    procesar(Entrada),
    !.

% si no hay preguntas
preguntar_dinamico.


% cuenta cuántas carreras quedan
contar_candidatas(Cantidad) :-
    findall(C, candidata(C), Lista), % Encuentra todas las carreras candidatas y las pone en una lista
    length(Lista, Cantidad).


% muestra resultados
mostrar_resultado :-
    findall(C, candidata(C), Lista),
    Lista \= [], % Si la lista no está vacía, muestra las opciones
    write('Te recomiendo:'), nl,
    mostrar_lista(Lista).

% si no hay opciones
mostrar_resultado :-
    write('No encontre una carrera adecuada'), nl.


% imprime la lista
mostrar_lista([]).
mostrar_lista([Carrera|Resto]) :- % Imprime el primer elemento
    write('- '), write(Carrera), nl,
    mostrar_lista(Resto).


% borra toda la memoria
limpiar_datos :-
    retractall(gusta(_)),
    retractall(no_gusta(_)),
    retractall(candidata(_)).


% ciclo principal
loop :-
    filtrar,
    contar_candidatas(Cantidad),
    decidir(Cantidad).


% decide si termina o sigue preguntando

% si queda una o ninguna carrera termina
decidir(Cantidad) :-
    Cantidad =< 1,
    mostrar_resultado.

% si ya no hay nada nuevo que preguntar termina aunque haya varias
decidir(_) :-
    \+ hay_preguntas_pendientes,
    mostrar_resultado.

% si aun hay varias opciones y preguntas pendientes sigue preguntando
decidir(Cantidad) :-
    Cantidad > 1,
    preguntar_dinamico,
    loop.