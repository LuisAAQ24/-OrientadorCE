:- consult('BD.pl').

%Gustos estáticos para probar y modificarlos según la prueba
gusta(matematicas).
%gusta(resolver_problemas).
%gusta(tecnologia).

%Dividir carrera en partes, Nombre, afinidades(lista), habilidades(lista) y defectos(lista)
recomendar(Carrera) :-
    profesion(Carrera, Afinidades, _, Defectos),
    sigustos(Afinidades),
    nodefectos(Defectos).

sigustos([]). %Caso base
sigustos([H|T]) :- %Recorrer lista de afinidades
    gusta(H),
    sigustos(T).

nodefectos([]). %Caso base
nodefectos([H|T]) :- %Recorrer lista de defectos
    \+ gusta(H),
    nodefectos(T).