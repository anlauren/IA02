concat([], L, L).
concat([T|Q], L, [T|R]):- concat(Q,L,R).
renverser([],[]).
renverser([T|Q],R):-renverser(Q,QR), concat(QR,[T], R).
nieme(1,[X|_],X) :- !.
nieme(N,[_|R],X) :- N1 is N-1, nieme(N1,R,X). %N : le numéro de la case, deuxième argument : liste à tranmettre, X : le résultat
compte([],0).
compte([_|R],N) :- compte(R,N1), N is N1+1, N>0.

%%%%%%%%%%%%%%%%%%% MENU %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
awale:- nl,
write('1: jouer à deux joueurs'),
nl,
write('2: jouer contre IA'),
nl,
write('3: IA vs IA'),
nl,
write('4: jouer contre IA en étant conseillé'),
nl,
write('entrez le numéro correspondant à votre choix'),
nl,
read(Choix),
nl,
write('votre choix est'),
write(Choix),
nl,
lancerjeu(Choix).


lancerjeu(1):-commencerjeu,!.
lancerjeu(2):-ia_commencerjeu,!.
lancerjeu(3):-iaia_commencerjeu,!.
lancerjeu(4):-oh_commencerjeu, !.
lancerjeu(_):-write('Vous avez mal choisi'), awale.

%%%%%%%%%%%%%%%%%%% RETOURNE LE MAX D'UNE LISTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%retourne_Max(Max, Sommet, Liste)
retourne_Max(Max, [Max]).
retourne_Max(Max, [T|[T1|Q1]]):- T>=T1, retourne_Max(Max,[T|Q1]).
retourne_Max(Max, [T|[T1|Q1]]):- T=<T1, retourne_Max(Max, [T1|Q1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% RETOURNE LE MIN D'UNE LISTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%retourne_Min(Min, Sommet, Liste)
retourne_Min(Min, [Max]).
retourne_Min(Min, [T|[T1|Q1]]):- T=<T1, retourne_Min(Min,[T|Q1]).
retourne_Min(Min, [T|[T1|Q1]]):- T>=T1, retourne_Min(Min, [T1|Q1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% RETOURNE LA POSITION D'UNE VALEURE DANS UNE LISTE %%%%%%%%%%%%%%%%%
%retourne_Max(Valeur, Position, Liste). Fail si pas dans la liste

retourne_Pos(Val,Pos, [T|Q]):- T=Val, compte(Q, X),  Pos is 6  - X.
retourne_Pos(Val,Pos, [T|Q]):- retourne_Pos(Val,Pos, Q).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
affichePlateau(P1,P2):- write('Son Plateau    :'), write(P2), nl, write('votre Plateau  :'), write(P1), nl.
affichePlateau2(P1,P2):- write('Plateau Ordi 1   :'), write(P2), nl, write('Plateau Ordi 2   :'), write(P1), nl.
% affichePlateau(P2,P1):- write('Joueur1 :'), renverser(P2, NP2), write(NP2), nl, write('Joueur 2 :'), write(P1), nl.
nombreGrainesDansCase(Case,PJ1, NBGraines):- nieme(Case,PJ1, NBGraines).
siPremiereDistributionPossible( PJ1, PJ2, Case, NBGrainesCase):- PJ2 \= [0,0,0,0,0,0],nieme(Case,PJ1, X), X\=0, Case>=1, Case=<6,!.
siPremiereDistributionPossible(PJ1, PJ2, Case, NBGrainesCase):- nombreGrainesDansCase(Case,PJ1, NBGrainesCase), 6-Case < NBGrainesCase, nieme(Case,PJ1, X), X\=0, Case>=1, Case=<6,!.


ajouterUneGraineCase(Case,[],[], NumCase).
ajouterUneGraineCase(Case,[H|T],[X|Y], NumCase):-
													N is NumCase +1,
													N= Case,
													ajouterUneGraineCase(Case,T,Y, N),
													X is H+1.
ajouterUneGraineCase(Case,[H|T],[H|Y], NumCase):- N is NumCase +1, N \= Case,
													ajouterUneGraineCase(Case,T,Y, N).



commencerjeu:- affichePlateau([4,4,4,4,4,4],[4,4,4,4,4,4]), faireJouerJoueur([4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).




distribuerSurPlateau(0, Case, NBGrainesCase, PJ1, PJ1, CaseArrivee, Nbr):- NBGrainesCase == 0, compte(PJ1, X), CaseArrivee is 6 - X, Nbr is NBGrainesCase,  !.

distribuerSurPlateau(0, Case, NBGrainesCase, [], [], CaseArrivee,NBGrainesRestantes ):- CaseArrivee is -90, NBGrainesRestantes is NBGrainesCase, !.

distribuerSurPlateau(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case = 1,
																								T1 is 0,
																								Case2 is Case-1,
																								distribuerSurPlateau(0, Case2, T, Q, Q1, CaseArrivee, NBGrainesRestantes).

distribuerSurPlateau(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case > 1,
																								Case2 is Case-1,
																								T1 is T,
																								distribuerSurPlateau(0, Case2, NBGrainesCase, Q, Q1, CaseArrivee, NBGrainesRestantes),!.
distribuerSurPlateau(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case = 1,
																								T1 is 0,
																								Case2 is Case-1,
																								distribuerSurPlateau(0, Case2, T, Q, Q1, CaseArrivee, NBGrainesRestantes).
distribuerSurPlateau(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case < 1,
																								T1 is T+1,
																								N is NBGrainesCase -1,
																								Case2 is Case-1,
																								distribuerSurPlateau(0, Case2, N, Q, Q1, CaseArrivee, NBGrainesRestantes).






distribuerSurPlateau(1, Case,0, L1, L1,CaseArrivee, N):- CaseArrivee is Case+1,N is 0, !.
distribuerSurPlateau(1,Case,NBGrainesCase, [],[],CaseArrivee, N):- CaseArrivee is -99, N is NBGrainesCase,! .
distribuerSurPlateau(1, 6,NBGrainesCase, [T|Q], [T3|Q3],CaseArrivee, N) :- renverser([T|Q],[T1|Q1]),
																			T2 is T1+1,
																			N2 is NBGrainesCase -1,
																			distribuerSurPlateau(1, 5,N2, Q1, Q2,CaseArrivee, N),
																			renverser([T2|Q2], [T3|Q3]), !.

distribuerSurPlateau(1, Case,NBGrainesCase, [T|Q], [T1|Q1],CaseArrivee, N) :- Case2 is Case -1,
																			T1 is T +1,
																			N2 is NBGrainesCase -1,
																			distribuerSurPlateau(1,Case2,N2, Q, Q1,CaseArrivee, N).

calculNombreDeGrainesRamassees(J1, 7, [], [], CaseArrivee, GrainesRamassees) :- GrainesRamassees is 0, !.
calculNombreDeGrainesRamassees(J1, Case, [T|Q], [T|Q], CaseArrivee, GrainesRamassees) :- CaseArrivee =< Case,
																						T\=2, T\=3,
																						GrainesRamassees is 0, !.


calculNombreDeGrainesRamassees(J1, Case, [T|Q], [A|B], CaseArrivee, GrainesRamassees) :- Case < CaseArrivee,
																						A is T,
																						Case2 is Case +1,
calculNombreDeGrainesRamassees(J1,Case2, Q, B, CaseArrivee, GrainesRamassees), !.
calculNombreDeGrainesRamassees(J1, Case, [T|Q], [A|B], CaseArrivee, GrainesRamassees) :- T>1,
																							T<4,
																							Case2 is Case +1,
																							A is 0,
																							calculNombreDeGrainesRamassees(J1,Case2, Q, B, CaseArrivee, X),
																							GrainesRamassees is T + X,!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distribuerSurPlateau2(0, Case, NBGrainesCase, PJ1, PJ1, CaseArrivee, Nbr):- NBGrainesCase == 0, compte(PJ1, X), CaseArrivee is 6 - X, Nbr is NBGrainesCase, !.
distribuerSurPlateau2(0, Case, NBGrainesCase, [], [], CaseArrivee,NBGrainesRestantes ):- CaseArrivee is -90, NBGrainesRestantes is NBGrainesCase, !.
distribuerSurPlateau2(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case>1,
																								Case2 is Case-1,
																								N is NBGrainesCase -1,
																								T1 is T+1,
																								distribuerSurPlateau2(0, Case2, N, Q, Q1, CaseArrivee, NBGrainesRestantes),!.
distribuerSurPlateau2(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case = 1,
																								T1 is 0,
																								Case2 is Case-1,
																								distribuerSurPlateau2(0, Case2, NBGrainesCase, Q, Q1, CaseArrivee, NBGrainesRestantes).
distribuerSurPlateau2(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case < 1,
																								T1 is T+1,
																								N is NBGrainesCase -1,
																								Case2 is Case-1,
																								distribuerSurPlateau2(0, Case2, N, Q, Q1, CaseArrivee, NBGrainesRestantes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tourPlateau(Joueur, PJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain):- Joueur = 0, write('tour plateau1 0'), distribuerSurPlateau(0, Case,NombreDeGrainesCase,PJ1, NewPJ1, CaseArrivee, GrainesMain), CaseArrivee<0,
																						tourPlateau(1, NewPJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees,GrainesMain).
tourPlateau(Joueur, PJ1, PJ2, Case, NewPJ1, NewNewPJ2, NBGrainesRamassees, GrainesMain):- Joueur = 1, write('TourPlateau1 1'), distribuerSurPlateau(1, 6, GrainesMain,PJ2, NewPJ2, CaseArrivee, NBGrainesRestantes), CaseArrivee<0,
																						tourPlateau2(0, PJ1, NewPJ2, Case, NewPJ1, NewNewPJ2, NBGrainesRamassees, NBGrainesRestantes).
tourPlateau(0,PJ1, PJ2, Case, NewPJ1, PJ2, NBGrainesRamassees, GrainesMain):-write('predicat simple'), distribuerSurPlateau(0, Case,GrainesMain,PJ1, NewPJ1, CaseArrivee, NBGrainesRestantes), CaseArrivee>=0,NBGrainesRamassees is 0,!.
tourPlateau(1, PJ1, PJ2, Case, PJ1, NewPJ2, NBGrainesRamassees, GrainesMain):- write('3EME '), distribuerSurPlateau(1, 6, GrainesMain,PJ2, NewNewPJ2, CaseArrivee, NBGrainesRestantes), CaseArrivee>=0,write(CaseArrivee),calculNombreDeGrainesRamassees(J2, 1, NewNewPJ2, NewPJ2, CaseArrivee, NBGrainesRamassees), !.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tourPlateau2(Joueur, PJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain):- Joueur = 0, write('tourPlateau2 0'), distribuerSurPlateau2(0, Case,GrainesMain,PJ1, NewPJ1, CaseArrivee, NBGrainesRestantes), CaseArrivee<0,
																						tourPlateau(1, NewPJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees,NBGrainesRestantes).
tourPlateau2(0,PJ1, PJ2, Case, NewPJ1, PJ2, NBGrainesRamassees, GrainesMain):-write('hop'), distribuerSurPlateau2(0, Case,GrainesMain,PJ1, NewPJ1, CaseArrivee, NBGrainesRestantes), CaseArrivee>=0,NBGrainesRamassees is 0,!.

faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- 	nl,
													write('Joueur1, à vous de jouer !'), nl,
													affichePlateau(PJ1,PJ2),
													write('rentrez le numero de la case que vous voulez jouer'),nl,
													read(X),
													siPremiereDistributionPossible( PJ1, PJ2, X, NBGrainesCase),
													tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain),
													SCOREJ12 is SCOREJ1 + NBGrainesRamassees,
													nl,
													affichePlateau(NewPJ1, NewPJ2),
													nl,
													write('Score joueur 1 :'),
													write(SCOREJ12),
													nl,
													write('Score joueur 2 :'),
													write(SCOREJ2),
													nl,
													\+partiefinie(SCOREJ12,SCOREJ2),
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
													faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1),!.
faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- 	nl, 	\+partiefinie(SCOREJ1,SCOREJ2),
													write('Votre coup n est pas possible, veuillez rejouer'),
													faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,0).													
faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
													write('Joueur2, à vous de jouer !'),nl,
													affichePlateau(PJ2,PJ1),
													write('rentrez le numero de la case que vous voulez jouer'),nl,
													read(X),
													siPremiereDistributionPossible( PJ2, PJ1, X, NBGrainesCase),
													tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, GrainesMain),
													SCOREJ22 is SCOREJ2 + NBGrainesRamassees,
													nl,
													affichePlateau(NewPJ2, NewPJ1),
													nl,
													write('Score joueur 1 :'),
													write(SCOREJ1),
													nl,
													write('Score joueur 2 :'),
													write(SCOREJ22),
													nl,
													\+partiefinie(SCOREJ1,SCOREJ22),
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
													faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
													
faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- 	nl, \+partiefinie(SCOREJ1,SCOREJ2),
													write('Votre coup n est pas possible, veuillez rejouer'),
													faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,1).	
%%%%%%%%%%%%%%%%%%%%%%%%%%%  IA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
explore1(L, PJ1, PJ2) :- explore1(1, L, PJ1, PJ2).
explore1(7,[],_, _).
explore1(Case, [T|Q], PJ1, PJ2) :-
				tourPlateau(0,PJ1, PJ2, Case, NewPJ1, NewPJ2, GrainesRamassees, GrainesMain),
				renverser(NewPJ1, InvPJ1),
				renverser(NewPJ2, InvPJ2),
				explore2(L,InvPJ1, InvPJ2), 
				retourne_Max(T, L),
				Case2 is Case +1,
				explore1(Case2, Q, PJ1, PJ2).
explore2(L, PJ1, PJ2) :- explore2(1, L, PJ1, PJ2).
explore2(7, [], _,_).
explore2(Case, [T|Q], PJ1, PJ2) :-
				tourPlateau(0,PJ2, PJ1, Case, NewPJ2, NewPJ1, T, GrainesMain),
				Case2 is Case + 1,
				explore2(Case2, Q, PJ1, PJ2).
choisiCaseIA(PJ1, PJ2, Case) :- explore1(L ,PJ1, PJ2), retourne_Min(Min, L), retourne_Pos(Min, Case, L).

%%%%%%%%%%%%%%%%%%%%% MODE DE JEU IA %%%%%%%%%%%%%%%%%%%%%%%%%%%
ia_commencerjeu:- affichePlateau([4,4,4,4,4,4],[4,4,4,4,4,4]), ia_faireJouerJoueur([4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).
ia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- 	nl,
													write('Joueur1, à vous de jouer !'), nl,
													affichePlateau(PJ1,PJ2),
													write('rentrez le numero de la case que vous voulez jouer'),nl,
													read(X),
													siPremiereDistributionPossible( PJ1, PJ2, X, NBGrainesCase),
													tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain),
													SCOREJ12 is SCOREJ1 + NBGrainesRamassees,
													nl,
													affichePlateau(NewPJ1, NewPJ2),
													nl,
													write('Score joueur 1 :'),
													write(SCOREJ12),
													nl,
													write('Score joueur 2 :'),
													write(SCOREJ2),
													nl,
\+partiefinie(SCOREJ12,SCOREJ2),
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
													ia_faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1),!.
ia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- 	nl, \+partiefinie(SCOREJ1,SCOREJ2),
				
													write('Votre coup n est pas possible, veuillez rejouer'),
													ia_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,0).													
ia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
													write('L ordinateur joue !'),nl,
													choisiCaseIA(PJ1, PJ2, X),
													siPremiereDistributionPossible( PJ2, PJ1, X, NBGrainesCase),
													tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, GrainesMain),
													SCOREJ22 is SCOREJ2 + NBGrainesRamassees,
													write('Score joueur 1 :'),
													write(SCOREJ1),
													nl,
													write('Score joueur 2 :'),
													write(SCOREJ22),
													nl,
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
\+partiefinie(SCOREJ1,SCOREJ22),
													ia_faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
													
ia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- 	nl, \+partiefinie(SCOREJ1,SCOREJ2),
				
													write('Votre coup n est pas possible, veuillez rejouer'),
													ia_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,1).	

%%%%%%%%%%%%%%%%%%%%%%%%%% GAGNANT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

partiefinie(SCOREJ1, SCOREJ2):- SCOREJ2>=25, write('Félicitations, Joueur2 vous avez gagné!'), read(X),!.
partiefinie(SCOREJ1, SCOREJ2):- SCOREJ1>=25, write('Félicitations, Joueur1 vous avez gagné!'), read(X),!.
%faudrait peut être que ça s'arrete un jour autrement qu avec read
%et ce foutu cycle?




%%%%%%%%%%%%%%%%%%%%% IA VS IA %%%%%%%%%%%%%%%%%%%%%%%%%%%
iaia_commencerjeu:- affichePlateau2([4,4,4,4,4,4],[4,4,4,4,4,4]), iaia_faireJouerJoueur([4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).

iaia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- 	nl,
													write('Ordinateur 1 joue'),nl,
													choisiCaseIA(PJ1, PJ2, X), %ou le contraire
													siPremiereDistributionPossible( PJ1, PJ2, X, NBGrainesCase),
													tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain),
													SCOREJ12 is SCOREJ1 + NBGrainesRamassees,
nl,
													affichePlateau2(NewPJ1, NewPJ2),
													nl,
													write('Score ordi 1 :'),
													write(SCOREJ12),
													nl,
													write('Score ordi 2 :'),
													write(SCOREJ2),
													nl,
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
\+partiefinie(SCOREJ12,SCOREJ2),
													iaia_faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1).
%iaia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- 	nl, \+partiefinie(SCOREJ1,SCOREJ2),
			
													%write('Votre coup n est pas possible, veuillez rejouer'),
													%iaia_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,0).													
iaia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
													write('Ordinateur 2 joue'),nl,
													choisiCaseIA(PJ1, PJ2, X),
													siPremiereDistributionPossible( PJ2, PJ1, X, NBGrainesCase),
													tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, GrainesMain),
													SCOREJ22 is SCOREJ2 + NBGrainesRamassees,
nl,
												affichePlateau2(NewPJ2, NewPJ1),
													nl,
													write('Score ordi 1 :'),
													write(SCOREJ1),
													nl,
													write('Score ordi 2 :'),
													write(SCOREJ22),
													nl,
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
\+partiefinie(SCOREJ1,SCOREJ22),
													iaia_faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
													
%iaia_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- 	nl, \+partiefinie(SCOREJ1,SCOREJ2),
				
													%write('Votre coup n est pas possible, veuillez rejouer')
													%iaia_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,1).
			%faudrait peut être qu il souffle de temps en temps






%%%%%%%%%%%%%%%%%%%%% JE VEUX ETRE CONSEILLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
oh_commencerjeu:- affichePlateau([4,4,4,4,4,4],[4,4,4,4,4,4]), oh_faireJouerJoueur([4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).
oh_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl,
write('Joueur1, à vous de jouer !'), nl,
affichePlateau(PJ1,PJ2), nl,
choisiCaseIA(PJ1, PJ2, Y), nl,
siPremiereDistributionPossible( PJ1, PJ2, Y, NBGrainesCase), nl,

write('Vous pourriez jouer '), write(Y), write(' par exemple...'), nl,
write('rentrez le numero de la case que vous voulez jouer'),nl,
read(X),
siPremiereDistributionPossible( PJ1, PJ2, X, NBGrainesCase),
tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain),
SCOREJ12 is SCOREJ1 + NBGrainesRamassees,
nl,
affichePlateau(NewPJ1, NewPJ2),
nl,
write('Score joueur 1 :'),
write(SCOREJ12),
nl,
write('Score joueur 2 :'),
write(SCOREJ2),
nl,
\+partiefinie(SCOREJ12,SCOREJ2),
renverser(NewPJ1, InvPJ1),
renverser(NewPJ2, InvPJ2),
oh_faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1),!.
oh_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl, \+partiefinie(SCOREJ1,SCOREJ2),
write('Votre coup n est pas possible, veuillez rejouer'),
oh_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,0).


oh_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
write('L ordinateur joue !'),nl,
choisiCaseIA(PJ1, PJ2, X),
siPremiereDistributionPossible( PJ2, PJ1, X, NBGrainesCase),
tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, GrainesMain),
SCOREJ22 is SCOREJ2 + NBGrainesRamassees,
write('Score joueur 1 :'),
write(SCOREJ1),
nl,
write('Score joueur 2 :'),
write(SCOREJ22),
nl,
renverser(NewPJ1, InvPJ1),
renverser(NewPJ2, InvPJ2),
\+partiefinie(SCOREJ1,SCOREJ22),
oh_faireJouerJoueur(InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
oh_faireJouerJoueur(PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl, \+partiefinie(SCOREJ1,SCOREJ2),
write('Votre coup n est pas possible, veuillez rejouer'),
oh_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,1).
