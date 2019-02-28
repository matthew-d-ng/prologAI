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

arc( [[H | T], OPath, OCost], [Dest, [Dest | OPath], Cost], KB ) :-
    member( [H | B], KB ),
    append( B, T, Dest ),
    length( B, L ),
    Tmp is L+1,
    Cost is OCost + Tmp.

heuristic( Node, H ) :-
    length( Node, H ).

goal( [] ).

less-than( [Node1, _, Cost1], [Node2, _, Cost2] ) :-
    heuristic( Node1, Hvalue1 ),
    heuristic( Node2, Hvalue2 ),
    F1 is Cost1 + Hvalue1,
    F2 is Cost2 + Hvalue2,
    F1 =< F2.

astar( [[Node, Path, Cost] | _], Path, Cost, _ ) :- 
    goal( Node ),
    !.

astar( [Head | Rest], FinalPath, FinalCost, KB ) :-
    findall( Child, arc( Head, Child, KB ), Children ),
    add_to_frontier( Children, Rest, NewFrontier ),
    astar( NewFrontier, FinalPath, FinalCost, KB).

add_to_frontier( [], Front, Front ).

add_to_frontier( [Child | MoreChildren], OldFront, NewFront ) :-
    insert( Child, OldFront, PartialFront ),
    add_to_frontier( MoreChildren, PartialFront, NewFront ).

insert( Node, [], [Node] ).

insert( Node, [Best | Rest], NewFront ) :-
    less-than(Node, Best),
    append( [Node], [Best | Rest], NewFront ),
    !.

insert( Node, [Best | Rest], NewFront ) :-
    insert( Node, Rest, PartialFront ),
    append( [Best], PartialFront, NewFront ).


