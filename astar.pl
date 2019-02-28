:- dynamic( kb/1 ).

makeKB( File ) :-
    open( File, read, Str ),
    readK( Str, K ), 
    reformat( K, KB ), 
    asserta( kb( KB ) ), 
    close( Str ).

readK( Stream, [] ) :- 
    at_end_of_stream( Stream ),
    !.

readK( Stream, [X | L] ) :- 
    read( Stream, X ),
    readK( Stream, L ).

reformat( [], [] ).

reformat( [end_of_file], [] ) :- 
    !.

reformat( [:-(H, B) | L], [[H | BL] | R] ) :- 
    !,
    mkList( B, BL ),
    reformat( L, R ).

reformat( [A | L], [[A] | R] ) :- 
    reformat(L,R).

mkList( (X, T), [X | R] ) :- 
    !,
    mkList( T, R ).

mkList( X, [X] ).

initKB( File ) :- 
    retractall( kb(_) ), 
    makeKB( File ).

%___________________________________________________________________
%___________________________________________________________________

astar( Node, Path, Cost ) :- 
    kb( KB ),
    astar( [[Node, [Node], 0]], Path, Cost, KB ).

arc( [H | T], Dest, Cost, KB ) :-
    member( [H | B], KB ),
    append( B, T, Dest ),
    length( B, L ),
    Cost is L+1.

heuristic( Node, H ) :-
    length( Node, H ).

goal( [] ).

less-than( [[Node1 | _], Cost1], [[Node2 | _], Cost2] ) :-
    heuristic( Node1, Hvalue1 ),
    heuristic( Node2, Hvalue2 ),
    F1 is Cost1 + Hvalue1,
    F2 is Cost2 + Hvalue2,
    F1 =< F2.

astar( [[Node, Path, Cost] | _], Path, Cost, _ ) :- 
    goal( Node ).

astar( [[Node, Path, Cost] | Rest], Path, Cost, KB ) :-
    findall( X, arc( Node, X ), Children ),
    add-to-frontier( Children, [Node, Path, Cost] | Rest], NewFrontier ),
    astar( NewFrontier, [Node | Path], Cost, KB).

add-to-frontier( [C | RestChild], [HeadFront | RestOldFrontier], NewFrontier ) :-
    less-than(  )
    add-to-frontier(  ).

