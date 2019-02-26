% Goal is to reduce a node down to []
goal([]).

% KB is Knowledge Base which basically represents the graph
kb(KB).
% It tells all possible expansions for a propositions
% So for example the proposition:
% d :- e 
% is encoded as [d,e]
% and we can replace the node [d,e,f] with [e,e,f]
% e is encoded as [e] which means we can replace [e,e,f] with [e,f]

% Takes the orgin node and returns a possible destination node as well as the cost of the edge/arc to that node
arc(OrginNode,DestNode,ArcCost,KB).
% so for example [q,c] and [q,a,b] are in KB and given [q] as input/orginNode it will return either [c] or [a,b]
% and the cost of the edge/arc to that node

% Takes two nodes and their costs so far and estimates which node has a lower cost based on 
% estimated_cost = cost_so_far + heurestic_cost
less_than([[Node1|_],Cost1],[[Node2|_],Cost2]).

% Function that calculates heurestic cost of a node
heurestic(Node,Heurestic_cost).

% A frontier is basically a list or queue like in Djikstra with the next node to expand at the head
% Takes a list of child nodes, the list of the other unexplored nodes and returns a new list
% The head of the list is the node with the lowest estimated cost ( which is the best node to expand next)
add_to_frontier(Children,Unexpanded_nodes,New_frontier).


% Takes the list of unexplored nodes and expands the head/best_node till we reach goal.
astar(Frontier,FinalCost,FinalPath,KB).
% Note that Astar is not a recursive algorithm since we may explore a node that ends up not being part of the 
% the best path
% One method to deal with this in both djikstra and A* is to store a cost_so_far and path_so_far for each node
% So when we reach goal the path_so_far and cost_so_far is the final cost and best path to goal
% Link to A* explanation and visualisation and python code if you want it:
% https://www.redblobgames.com/pathfinding/a-star/introduction.html