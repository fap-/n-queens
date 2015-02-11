% compute_queen_solution/2
% compute_queen_solution(N, FIELD) Returns a(ll) possible solution(s)
% for the n-queens puzzle (NxN game field)
compute_queen_solution(N, FIELD) :- fill_domain(N, N, Domains), fill_field(N, Domains, FIELD, N).

% fill_domain/3
% fill_domain(NumberOfRows, NumberOfColums, DomainSpace)
% Returns a matrix (as a list of lists) containing all possible
% locations of the queens.
fill_domain(0, _N, []) :- !.
fill_domain(NFields, N, [H|T]) :- numlist(1, N, H), NewNFields is NFields - 1,
	fill_domain(NewNFields, N, T).

% fill_field/3
% fill_field(N, Domains, NFields)
% Places queens on the chessboard in compliance with the rules.
fill_field(0, _Domain, [], _NFields).
fill_field(N, [DomainHead|DomainTail], [H|T], NFields) :- N > 0,
	member(H, DomainHead),
	restrict_field(DomainTail, H, 1, NewDomains, NFields),
	NewN is N-1,
	fill_field(NewN, NewDomains, T, NFields).

% restrict_field/4
% restrict_field(Domains, LastPick, MoveNumber, Solution, N)
% This takes the position of the queen on the current row (LastPick)
% and removes the positions that become forbidden through this pick in
% the consecutive rows.
restrict_field([], _LastPick, _CurrentRowNum, [], _NFields).
restrict_field([DomainsHead|DomainsTail], LastPick, MoveNumber, [NewDomainsHead3|NewDomainsTail], NFields) :-
	(member(LastPick, DomainsHead) -> delete(DomainsHead, LastPick, NewDomainsHead); DomainsHead = NewDomainsHead),
	MoveLeft is LastPick - MoveNumber,
	(MoveLeft > 0, member(MoveLeft, NewDomainsHead) -> delete(NewDomainsHead, MoveLeft, NewDomainsHead2); NewDomainsHead = NewDomainsHead2),
	MoveRight is LastPick + MoveNumber,
	(MoveRight =< NFields, member(MoveRight, NewDomainsHead2) -> delete(NewDomainsHead2, MoveRight, NewDomainsHead3); NewDomainsHead2 = NewDomainsHead3),
	NewMoveNumber is MoveNumber + 1,
	restrict_field(DomainsTail, LastPick, NewMoveNumber, NewDomainsTail, NFields).
