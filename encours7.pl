
%%%%%%%%%%%%%%%%%%%%% PREDICATS PRELIMINAIRES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concat([], L, L).
concat([T|Q], L, [T|R]):- concat(Q,L,R).


%renverser(A,B) permet d'unifier la liste A inversée avec B
renverser([],[]).
renverser([T|Q],R):-renverser(Q,QR), concat(QR,[T], R).

%nieme(N, L, X) N : le numéro de la case, L : liste à tranmettre, X : ce que contient la case N
nieme(1,[X|_],X) :- !.
nieme(N,[_|R],X) :- N1 is N-1, nieme(N1,R,X). 

%compte(L, N) renvoie le nombre d'élements N de la liste L
compte([],0).
compte([_|R],N) :- compte(R,N1), N is N1+1, N>0.


ajoute_element(X, Q2, [X|Q2]).



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
%retourne_Max(Max, Liste) renvoie dans Max la valeur maximale contenue dans Liste
retourne_Max(Max, [Max]).
retourne_Max(Max, [T|[T1|Q1]]):- T>=T1, retourne_Max(Max,[T|Q1]).
retourne_Max(Max, [T|[T1|Q1]]):- T=<T1, retourne_Max(Max, [T1|Q1]).


%%%%%%%%%%%%%%%%%%% RETOURNE LE MIN D'UNE LISTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%retourne_Min(Min, Liste) renvoie dans Min la valeur minimale contenue dans Liste
retourne_Min(_, [_]). 
retourne_Min(Min, [T|[T1|Q1]]):- T=<T1, retourne_Min(Min,[T|Q1]).
retourne_Min(Min, [T|[T1|Q1]]):- T>=T1, retourne_Min(Min, [T1|Q1]).


%%%%%%%%%%%%%%%%%%% RETOURNE LA POSITION D'UNE VALEUR DANS UNE LISTE %%%%%%%%%%%%%%%%%
%retourne_Max(Valeur, Position, Liste). retourne dans Position la position de Valeur dans Liste.Fail si pas dans la liste

retourne_Pos(Val,Pos, [T|Q]):- T=Val, compte(Q, X), Pos is 6 - X.
retourne_Pos(Val,Pos, [_|Q]):- retourne_Pos(Val,Pos, Q).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
affichePlateau(P1,P2):- write('                _____________'),
			nl, 
			write('Son Plateau :   '), 
			plateau(P2), 
			nl,
			write('                -------------'),
			nl,
			write('Votre Plateau : '), 
			plateau(P1), 
			nl,
			write('                ~~~~~~~~~~~~~'),
			nl.
							
									
affichePlateau2(P1,P2):-write('                _____________'),
			nl, 
			write('Plateau Ordi 1 :'), plateau(P2), 
			nl,
			write('                -------------'),
			nl, 
			write('Plateau Ordi 2 :'),
			plateau(P1), 
			nl,
			write('                ~~~~~~~~~~~~~'),
			nl.

plateau([]):-write('|').	
plateau([T|Q]):-write('|'), write(T), plateau(Q).

%%%%%%%%%%%%%%%%%%%% SI PREMIERE DISTRIBUTION POSSIBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%siPremiereDistributionPossible(PJ1, PJ2, Case, NBGrainesCase) est vrai si: le plateau de l'adversaire n'est pas vide ou si la Case jouée va introduire des graines dans son plateau
                                                                            
siPremiereDistributionPossible(PJ1, PJ2, Case):-siPremiereDistributionPossible(PJ1, PJ2, Case, _).

siPremiereDistributionPossible( PJ1, PJ2, Case, _):- PJ2 \= [0,0,0,0,0,0],
					             nieme(Case,PJ1, X), 
					             X\=0, 	
						     Case>=1,														 
						     Case=<6,!.
siPremiereDistributionPossible(PJ1, _, Case, NBGrainesCase):- nieme(Case,PJ1, NBGrainesCase), 
							      6-Case < NBGrainesCase, 
							      nieme(Case,PJ1, X), 
				                              X\=0, 
							      Case>=1, 
							      Case=<6,!.
							      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  DISTRIBUER SUR PLATEAU  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%distribuerSurPlateau(0, Case, NBGrainesCase, PJ1, PJ1, CaseArrivee, NBGrainesRestantes) va distribuer les graines de Case(=NBGrainesCase) dans PJ1(c'est-à-dire le plateau du joueur dont c'est le tour).

%si le nombre de graines est épuisé distribuerSurPlateau renvoie dans CaseArrivée la dernière Case où il a déposé une graine.
distribuerSurPlateau(0, _, 0, PJ1, PJ1, CaseArrivee, 0):-  
																		   compte(PJ1, X), 
																		   CaseArrivee is 6 - X, !.

%s'il reste encore des graines alors que PJ1 a été entièrement exploré, distribuerSurPlateau renvoie que CaseArrivee est -90 ce qui va permettre dde distribuer sur le plateau du joueur adverse
distribuerSurPlateau(0, _, NBGrainesCase, [], [], CaseArrivee,NBGrainesRestantes ):- CaseArrivee is -90, 
																						NBGrainesRestantes is NBGrainesCase, !.
%Lorsque distribuerSurPlateau explore la Case de départ, il la met à 0 avant de continuer
distribuerSurPlateau(0, Case, _, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case = 1,
																							    T1 is 0,
																							    Case2 is Case-1,
																								distribuerSurPlateau(0, Case2, T, Q, Q1, CaseArrivee, NBGrainesRestantes).
%Quand il explore le plateau avant la case de départ ou après que toutes les graines aient été distribuées, il passe à la suite en renvoyant les même valeurs dans le nouveau plateau
distribuerSurPlateau(0, Case, NBGrainesCase, [T|Q], [T|Q1], CaseArrivee, NBGrainesRestantes):- Case > 1,
																								Case2 is Case-1,
																								distribuerSurPlateau(0, Case2, NBGrainesCase, Q, Q1, CaseArrivee, NBGrainesRestantes),!.
%Sur les cases où il peut distribuer il ajoute 1 sur le plateau et enlève 1 à NBGrainesCase																						
distribuerSurPlateau(0, Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case < 1,
																								T1 is T+1,
																								N is NBGrainesCase -1,
																								Case2 is Case-1,
																								distribuerSurPlateau(0, Case2, N, Q, Q1, CaseArrivee, NBGrainesRestantes).



%distribuerSurPlateau(1, Case,NBGrainesCase, L1, L2 ,CaseArrivee, N) distribue les graines contenues dans NBGrainesCase dans le plateau de l'adversaire jusqu'à ce qu'elles soient épuisées, ou qu'il doive renvoyer au plateau du joueur dont c'est le tour

%s'il n'y a plus rien dans NBGrainesCase  il renvoie la case d'arrivée
distribuerSurPlateau(1, Case,0, L1, L1,CaseArrivee, 0):- CaseArrivee is Case+1, !.

%s'il reste des graines lorsque tout le plateau a été exploré il renvoie que -99 dans CaseArrivee qui permettra de relancer distribuerSurPlateau dans l'autre plateau (cf distribuerSurPlateau2)													
distribuerSurPlateau(1,_,NBGrainesCase, [],[],CaseArrivee, N):- CaseArrivee is -99, 
							        N is NBGrainesCase,! .
%Avant de commencer à distribuer sur le plateau adverse on renverse le plateau pour pouvoir distribuer correctement, et on renversera à nouveau après avoir fini la distribution							        
distribuerSurPlateau(1, 6,NBGrainesCase, [T|Q], [T3|Q3],CaseArrivee, N) :- renverser([T|Q],[T1|Q1]),
																		   T2 is T1+1,
																		   N2 is NBGrainesCase -1,
																		   distribuerSurPlateau(1, 5,N2, Q1, Q2,CaseArrivee, N),
																		   renverser([T2|Q2], [T3|Q3]), !.
																		   
%il explore le plateau en distribuant les graines quand il faut
distribuerSurPlateau(1, Case,NBGrainesCase, [T|Q], [T1|Q1],CaseArrivee, N) :- Case2 is Case -1,
																			  T1 is T +1,
																			  N2 is NBGrainesCase -1,
																			  distribuerSurPlateau(1,Case2,N2, Q, Q1,CaseArrivee, N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

%calculNombreDeGrainesRamassees( Case, [T|Q], [T|Q], CaseArrivee, GrainesRamassees)	renvoie dans GrainesRamassees les graines remportées par le joueur lors de son tour et les enleve du plateau.

calculNombreDeGrainesRamassees( L1, L2, CaseArrivee, NBGrainesRamassees):- calculNombreDeGrainesRamassees( 1, L1, L2, CaseArrivee, NBGrainesRamassees).																			  
		
%On parcourt tout le plateau, de Case=1 jusqu'à Case=7, il remonte ensuite.
calculNombreDeGrainesRamassees( 7, [], [], _, GrainesRamassees) :- GrainesRamassees is 0, !.

%une fois qu'on a atteint CaseArrivee on s'arrete lorsque celle ci ou une des suivantes contient autre chose que 2 ou 3 graines, dans ce cas on remonte le prédicat.
calculNombreDeGrainesRamassees( Case, [T|Q], [T|Q], CaseArrivee, GrainesRamassees) :- CaseArrivee =< Case,
																					   	 T\=2, T\=3,
																						 GrainesRamassees is 0, !.
%Tant qu'on a pas atteint CaseArrivee on se contente de renvoyer l'element dans la liste suivante et de passer à la case suivante
calculNombreDeGrainesRamassees( Case, [T|Q], [A|B], CaseArrivee, GrainesRamassees) :- Case < CaseArrivee,
																						 A is T,
																						 Case2 is Case +1,
																						 calculNombreDeGrainesRamassees(Case2, Q, B, CaseArrivee, GrainesRamassees), !.
%Si dans la case d'arrivée il y a deux ou trois graines on les ajoute à GrainesRamassees et on vide la case. On passe à la case suivante, et on réitère s'il y a aussi deux ou trois graines sinon cela renvoie au prédicat au-dessus 																						 
calculNombreDeGrainesRamassees( Case, [T|Q], [A|B], CaseArrivee, GrainesRamassees) :- T>1,
																						 T<4,
																						 Case2 is Case +1,
																						 A is 0,
																						 calculNombreDeGrainesRamassees(Case2, Q, B, CaseArrivee, X),
																						 GrainesRamassees is T + X,!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%distribuerSurPlateau2( Case, NBGrainesCase, PJ1, PJ1, CaseArrivee, Nbr) sert quand on a fait un tour complet lors de la distribution des graines et que l'on retourne sur le plateau du joueur dont c'est le tour.

%Quand on a fini de distribuer Nbr et NBGrainesCase sont à 0. On calcule CaseArrivee pour avoir une valeur positive qui signifie que la distribution est terminée
distribuerSurPlateau2( _, 0, PJ1, PJ1, CaseArrivee, 0):- compte(PJ1, X), 
														 CaseArrivee is 6 - X, !.
														 
%S'il reste encore des graines à la fin de la distribution sur ce plateau CaseArrivee=-90 ce qui permettra de rappeler distribuerSurPlateau sur le plateau de l'adversaire																			
distribuerSurPlateau2( _, NBGrainesCase, [], [], CaseArrivee,NBGrainesRestantes ):- CaseArrivee is -90, 
																						 NBGrainesRestantes is NBGrainesCase, !.
%ici même avant d'atteindre la case de départ on distribue car il s'agit de la deuxieme distribution																						 
distribuerSurPlateau2( Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case>1,
																							 Case2 is Case-1,
																								 N is NBGrainesCase -1,
																								 T1 is T+1,
																								 distribuerSurPlateau2( Case2, N, Q, Q1, CaseArrivee, NBGrainesRestantes),!.
%les deux prédicats suivants suivent la même logique que pour distribuerSurPlateau(0,...)																								 
distribuerSurPlateau2( Case, NBGrainesCase, [_|Q], [0|Q1], CaseArrivee, NBGrainesRestantes):- Case = 1,
																								 Case2 is Case-1,
																								 distribuerSurPlateau2( Case2, NBGrainesCase, Q, Q1, CaseArrivee, NBGrainesRestantes).
distribuerSurPlateau2( Case, NBGrainesCase, [T|Q], [T1|Q1], CaseArrivee, NBGrainesRestantes):- Case < 1,
																								 T1 is T+1,
																								 N is NBGrainesCase -1,
																								 Case2 is Case-1,
																								 distribuerSurPlateau2( Case2, N, Q, Q1, CaseArrivee, NBGrainesRestantes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tourPlateau lance la distribution sur le plateau du joueur, puis lance la distribution sur le plateau sur le plateau suivant si CaseArrivee<0 (signal que la distribution n'est pas terminée)
tourPlateau(0, PJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain):- 
																						  distribuerSurPlateau(0, Case,_,PJ1, NewPJ1, CaseArrivee, GrainesMain), 
																						  CaseArrivee<0,
																						  tourPlateau(1, NewPJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees,GrainesMain).
tourPlateau(1, PJ1, PJ2, Case, NewPJ1, NewNewPJ2, NBGrainesRamassees, GrainesMain):-  
																					  	  distribuerSurPlateau(1, 6, GrainesMain,PJ2, NewPJ2, CaseArrivee, NBGrainesRestantes), 
																						  CaseArrivee<0,
																						  tourPlateau2(0, PJ1, NewPJ2, Case, NewPJ1, NewNewPJ2, NBGrainesRamassees, NBGrainesRestantes).
%Lorsque la distribution est terminée tourPlateau définie NBGrainesRamassees comme égale à 0 si cela finit sur le plateau du joueur actif sinon il le calcule et ne se rappelle plus lui-même.																						  
tourPlateau(0,PJ1, PJ2, Case, NewPJ1, PJ2, NBGrainesRamassees, GrainesMain):-
																			 distribuerSurPlateau(0, Case,GrainesMain,PJ1, NewPJ1, CaseArrivee, _), 
																			 CaseArrivee>=0,
																			 NBGrainesRamassees is 0,!.
tourPlateau(1,PJ1, PJ2, _, PJ1, NewPJ2, NBGrainesRamassees, GrainesMain):- distribuerSurPlateau(1, 6, GrainesMain,PJ2, NewNewPJ2, CaseArrivee, _), 
																			  CaseArrivee>=0,
																		      calculNombreDeGrainesRamassees( NewNewPJ2, NewPJ2, CaseArrivee, NBGrainesRamassees), !.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Si la distribution des graines arrive sur le plateau du joueur actif c'est tourPlateau2 qui est appelé. Il va appeler distribuerSurPlateau2 avant de rappeler si besoin tourPlateau(1,...)
tourPlateau2(0, PJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees, GrainesMain):-  
																						   distribuerSurPlateau2( Case,GrainesMain,PJ1, NewPJ1, CaseArrivee, NBGrainesRestantes), 
																						   CaseArrivee<0,
																						   tourPlateau(1, NewPJ1, PJ2, Case, NewNewPJ1, NewPJ2, NBGrainesRamassees,NBGrainesRestantes).
tourPlateau2(0,PJ1, PJ2, Case, NewPJ1, PJ2, NBGrainesRamassees, GrainesMain):-distribuerSurPlateau2(Case,GrainesMain,PJ1, NewPJ1, CaseArrivee, _), 
																			  CaseArrivee>=0,
																			  NBGrainesRamassees is 0,!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODE DE JEU%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2 JOUEURS HUMAINS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

commencerjeu:- affichePlateau([4,4,4,4,4,4],[4,4,4,4,4,4]), 
			   faireJouerJoueur([],[],[4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).

%faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) LJ1 et LJ2 gardent en mémoir les coups joués pour permettre de savoir si le jeu cycle (cf partiefinie)
%il s'agit de l'interface avec l'utilisateur qui appelle les différents prédicats.
%Il va tester si la partie est finie avant de renverser les plateaux et de faire jouer l'autre joueur.
faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl,
															write('Joueur1, à vous de jouer !'), nl,
															affichePlateau(PJ1,PJ2),
															write('rentrez le numero de la case que vous voulez jouer'),nl,
															read(X),
															siPremiereDistributionPossible( PJ1, PJ2, X),
															ajoute_element(X, LJ1, NewLJ1),
															tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, _),
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
															\+partiefinie(SCOREJ12,SCOREJ2, NewLJ1, LJ2, PJ1, PJ2),
															renverser(NewPJ1, InvPJ1),
															renverser(NewPJ2, InvPJ2),
															faireJouerJoueur(newLJ1, LJ2, InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1),!.
%Si siPremiereDistributionPossible( PJ1, PJ2, X) échoue on relance le prédicat jusqu'à ce que le joueur propose un coup possible.														
faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl, \+partiefinie(SCOREJ1,SCOREJ2, LJ1, LJ2, PJ1, PJ2),
															write('Votre coup n est pas possible, veuillez rejouer'),
															faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,0).
faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
															write('Joueur2, à vous de jouer !'),nl,
															affichePlateau(PJ2,PJ1),
															write('rentrez le numero de la case que vous voulez jouer'),nl,
															read(X),
															siPremiereDistributionPossible( PJ2, PJ1, X),
															ajoute_element(X, LJ2, NewLJ2),
															tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, _),
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
															\+partiefinie(SCOREJ1,SCOREJ22, LJ1, NewLJ2, PJ1, PJ2),
															renverser(NewPJ1, InvPJ1),
															renverser(NewPJ2, InvPJ2),
															faireJouerJoueur(LJ1, NewLJ2, InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
															
faireJouerJoueur(LJ1, LJ2,PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl, \+partiefinie(SCOREJ1,SCOREJ2, LJ1,LJ2, PJ1, PJ2),
															write('Votre coup n est pas possible, veuillez rejouer'),
															faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,1).
%%%%%%%%%%%%%%%%%%%%%%%%%%% IA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
explore1(L, PJ1, PJ2) :- explore1(1, L, PJ1, PJ2).
explore1(7,[],_, _).
explore1(Case, [T|Q], PJ1, PJ2) :-
								nieme(Case, PJ1, Graines),
								Graines \=0,
								tourPlateau(0,PJ1, PJ2, Case, NewPJ1, NewPJ2, GrainesRamassees, _),
								renverser(NewPJ1, InvPJ1),
								renverser(NewPJ2, InvPJ2),
								explore2(L,InvPJ1, InvPJ2),
								retourne_Max(X, L),
								T is GrainesRamassees - X,
								Case2 is Case +1,
								explore1(Case2, Q, PJ1, PJ2),!.
explore1(Case, [T|Q], PJ1, PJ2) :- T is -99, Case2 is Case +1, explore1(Case2, Q, PJ1, PJ2).

explore2(L, PJ1, PJ2) :- explore2(1, L, PJ1, PJ2).
explore2(7, [], _,_).
explore2(Case, [T|Q], PJ1, PJ2) :-
									nieme(Case, PJ1, Graines),
									Graines \=0,
									tourPlateau(0,PJ2, PJ1, Case, NewPJ2, NewPJ1, T, _),
									Case2 is Case + 1,
									explore2(Case2, Q, PJ1, PJ2),!.
explore2(Case, [T|Q], PJ1, PJ2) :- T is -99, Case2 is Case +1, explore2(Case2, Q, PJ1, PJ2).
choisiCaseIA(PJ1, PJ2, Case) :- explore1(L ,PJ1, PJ2), retourne_Max(Max, L), retourne_Pos(Max, Case, L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IA FAIBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ici l'IA ne calcule que les gains potentiels sans regarder les gains de l'adversaire au tour d'après
exploref(L, PJ1, PJ2) :- exploref(1, L, PJ1, PJ2).
exploref(7,[],_, _).
exploref(Case, [T|Q], PJ1, PJ2) :-
								nieme(Case, PJ1, Graines),
								Graines \=0,
								tourPlateau(0,PJ1, PJ2, Case, NewPJ1, NewPJ2, GrainesRamassees, _),
								T is GrainesRamassees,
								Case2 is Case +1,
								exploref(Case2, Q, PJ1, PJ2),!.
exploref(Case, [T|Q], PJ1, PJ2) :- T is -99, Case2 is Case +1, exploref(Case2, Q, PJ1, PJ2).
choisiIAfaible(PJ1, PJ2, Case) :- exploref(L ,PJ1, PJ2), retourne_Max(Max, L), retourne_Pos(Max, Case, L),!.		
			
%%%%%%%%%%%%%%%%%%%%% JOUEUR VS IA %%%%%%%%%%%%%%%%%%%%%%%%%%%
ia_commencerjeu:- affichePlateau([4,4,4,4,4,4],[4,4,4,4,4,4]), ia_faireJouerJoueur([],[],[4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).

ia_faireJouerJoueur(LJ1, LJ2,PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl,
													write('Joueur1, à vous de jouer !'), nl,
													affichePlateau(PJ1,PJ2),
													write('rentrez le numero de la case que vous voulez jouer'),nl,
													read(X),
													siPremiereDistributionPossible( PJ1, PJ2, X),
													ajoute_element(X, LJ1, NewLJ1),
													tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, _),
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
													sleep(1),
													\+partiefinie(SCOREJ12,SCOREJ2, NewLJ1, LJ2, PJ1, PJ2),
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
													ia_faireJouerJoueur(NewLJ1, LJ2,InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1),!.
ia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl, \+partiefinie(SCOREJ1,SCOREJ2, LJ1, LJ2, PJ1, PJ2),
													write('Votre coup n est pas possible, veuillez rejouer'),
													ia_faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,0).
ia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
													write('L ordinateur joue !'),nl,
													choisiCaseIA(PJ2, PJ1, X),
													siPremiereDistributionPossible( PJ2, PJ1, X),
													ajoute_element(X, LJ2, NewLJ2),
													tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, _),
													SCOREJ22 is SCOREJ2 + NBGrainesRamassees,
													write('Score joueur 1 :'),
													write(SCOREJ1), 
													nl,
													write('Score joueur 2 :'),
													write(SCOREJ22),
													nl,
													sleep(1),
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
													\+partiefinie(SCOREJ1,SCOREJ22, LJ1, NewLJ2, PJ1, PJ2),
													ia_faireJouerJoueur(LJ1, NewLJ2, InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
													
	%ia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl, \+partiefinie(SCOREJ1,SCOREJ2, LJ1, LJ2, PJ1, PJ2),
													%write('Votre coup n est pas possible, veuillez rejouer'),
													%ia_faireJouerJoueur(PJ1,PJ2,SCOREJ1,SCOREJ2,1).

%%%%%%%%%%%%%%%%%%%%%%%%%% GAGNANT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%partiefinie(SCOREJ1, SCOREJ2, LJ1, LJ2, PJ1, PJ2)

partiefinie(_, SCOREJ2,_, _, _, _):- SCOREJ2>=25, write('Félicitations, Joueur2 vous avez gagné!'), read(_),!.
partiefinie(SCOREJ1, _, _, _, _, _):- SCOREJ1>=25, write('Félicitations, Joueur1 vous avez gagné!'), read(_),!.
partiefinie(SCOREJ1, SCOREJ2, LJ1, LJ2, PJ1, PJ2):- boucle(LJ1, LJ2), 
														ajouterscore(SCOREJ1, NewScoreJ1, SCOREJ2, NewScoreJ2, PJ1, PJ2), 
														NewScoreJ1>NewScoreJ2, 
														write('Félicitations, Joueur1 vous avez gagné!'), 
														read(_),!.
partiefinie(SCOREJ1, SCOREJ2, LJ1, LJ2, PJ1, PJ2):- boucle(LJ1, LJ2), 
														ajouterscore(SCOREJ1, NewScoreJ1, SCOREJ2, NewScoreJ2, PJ1, PJ2), 
														NewScoreJ2>NewScoreJ1, 
														write('Félicitations, Joueur2 vous avez gagné!'), 
														read(_),!.
partiefinie(SCOREJ1, SCOREJ2, _, _, PJ1, PJ2):- testsiPremiereDistributionPossible( PJ1, PJ2), 
														ajouterscore(SCOREJ1, NewScoreJ1, SCOREJ2, NewScoreJ2, PJ1, PJ2), 
														NewScoreJ2>NewScoreJ1, 
														write('Félicitations, Joueur2 vous avez gagné!'), 
														read(_),!.
partiefinie(SCOREJ1, SCOREJ2, _, _, PJ1, PJ2):- testsiPremiereDistributionPossible( PJ1, PJ2), 
														ajouterscore(SCOREJ1, NewScoreJ1, SCOREJ2, NewScoreJ2, PJ1, PJ2),
														NewScoreJ2<NewScoreJ1, 
														write('Félicitations, Joueur1 vous avez gagné!'), 
														read(_),!.
testsiPremiereDistributionPossible( PJ1, PJ2):- testsiPremiereDistributionPossible( PJ1, PJ2, 6).
testsiPremiereDistributionPossible( _,_, 0).
testsiPremiereDistributionPossible( PJ1, PJ2, Case):- \+siPremiereDistributionPossible( PJ1, PJ2, Case),
														Case2 is Case-1,
														testsiPremiereDistributionPossible( PJ1, PJ2, Case2).

boucle(L1, L2) :- compte(L1,X), X>5,compte(L2,Y), Y>5,
					nieme(1,L1, X1), nieme( 7,L1, Y1), Y1=X1, 
				   nieme(2,L1, X2), nieme( 8, L1,Y2), Y2=X2, 
				   nieme(3,L1, X3), nieme( 9,L1, Y3), Y3=X3,
				   nieme(4,L1, X4), nieme( 10, L1,Y4), Y4=X4, 
				   nieme(5,L1, X5), nieme( 11,L1, Y5), Y5=X5,
				   nieme(6,L1, X6), nieme( 12,L1, Y6), Y6=X6, 
				   nieme(1,L2,Z1 ), nieme( 7,L2, W1), Z1=W1,
				   nieme(2,L2,Z2 ), nieme( 8,L2, W2), Z2=W2,
				   nieme(3,L2,Z3 ), nieme( 9,L2, W3), Z3=W3,
				   nieme(4,L2,Z4 ), nieme( 10,L2, W4), Z4=W4,
				   nieme(5,L2,Z5 ), nieme( 11,L2, W5), Z5=W5,
				   nieme(6, L2,Z6 ), nieme(12,L2, W6), Z6=W6,!.
				   
boucle(L1, L2) :- compte(L1,X), X>5,compte(L2,Y), Y>5,
					nieme(1,L1, X1), nieme( 6,L1, Y1), Y1=X1, 
				   nieme(2,L1, X2), nieme( 7, L1,Y2), Y2=X2, 
				   nieme(3,L1, X3), nieme( 8,L1, Y3), Y3=X3,
				   nieme(4,L1, X4), nieme( 9, L1,Y4), Y4=X4, 
				   nieme(5,L1, X5), nieme( 10,L1, Y5), Y5=X5,
				    
				   nieme(1,L2,Z1 ), nieme( 6,L2, W1), Z1=W1,
				   nieme(2,L2,Z2 ), nieme( 7,L2, W2), Z2=W2,
				   nieme(3,L2,Z3 ), nieme( 8,L2, W3), Z3=W3,
				   nieme(4,L2,Z4 ), nieme( 9,L2, W4), Z4=W4,
				   nieme(5,L2,Z5 ), nieme( 10,L2, W5), Z5=W5,!.
				   
boucle(L1, L2) :- compte(L1,X), X>5,compte(L2,Y), Y>5,
					nieme(1,L1, X1), nieme( 5,L1, Y1), Y1=X1, 
				   nieme(2,L1, X2), nieme( 6, L1,Y2), Y2=X2, 
				   nieme(3,L1, X3), nieme( 7,L1, Y3), Y3=X3,
				   nieme(4,L1, X4), nieme( 8, L1,Y4), Y4=X4, 
				  
				   nieme(1,L2,Z1 ), nieme( 5,L2, W1), Z1=W1,
				   nieme(2,L2,Z2 ), nieme( 6,L2, W2), Z2=W2,
				   nieme(3,L2,Z3 ), nieme( 7,L2, W3), Z3=W3,
				   nieme(4,L2,Z4 ), nieme( 8,L2, W4), Z4=W4,!.
				  
				  				   
				   
ajouterscore(SCOREJ1, SCOREJ1, SCOREJ2, SCOREJ2, [], []).
ajouterscore(SCOREJ1, NewScoreJ1, SCOREJ2, NewScoreJ2, [T1|Q1], [T2|Q2]):- 
																		
																		 ajouterscore(SCOREJ1, NewNewScoreJ1, SCOREJ2, NewNewScoreJ2, Q1, Q2),
																		 NewScoreJ1 is NewNewScoreJ1 + T1,
																		 NewScoreJ2 is NewNewScoreJ2 + T2.
															
																		

%%%%%%%%%%%%%%%%%%%%% IA VS IA %%%%%%%%%%%%%%%%%%%%%%%%%%%
iaia_commencerjeu:- affichePlateau2([4,4,4,4,4,4],[4,4,4,4,4,4]), iaia_faireJouerJoueur([],[],[4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).

iaia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl,
								write('Ordinateur 1 joue'),nl,
								choisiCaseIA(PJ1, PJ2, X),
								siPremiereDistributionPossible( PJ1, PJ2, X),
								ajoute_element(X, LJ1, NewLJ1),
								tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, _),
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
								sleep(1),
								renverser(NewPJ1, InvPJ1),
								renverser(NewPJ2, InvPJ2),
								\+partiefinie(SCOREJ12,SCOREJ2, NewLJ1, LJ2, PJ1, PJ2),
								iaia_faireJouerJoueur(NewLJ1, LJ2, InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1).
%iaia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl, \+partiefinie(SCOREJ1,SCOREJ2),

%write('Votre coup n est pas possible, veuillez rejouer'),
%iaia_faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,0).	
iaia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
														write('Ordinateur 2 joue'),nl,
														choisiCaseIA(PJ2, PJ1, X),
														siPremiereDistributionPossible( PJ2, PJ1, X),
														ajoute_element(X, LJ2, NewLJ2),
														tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, _),
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
														sleep(1),
														renverser(NewPJ1, InvPJ1),
														renverser(NewPJ2, InvPJ2),
														\+partiefinie(SCOREJ1,SCOREJ22, LJ1, NewLJ2, PJ1, PJ2),
														iaia_faireJouerJoueur(LJ1, NewLJ2, InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).


%iaia_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl, \+partiefinie(SCOREJ1,SCOREJ2),

%write('Votre coup n est pas possible, veuillez rejouer'),
%iaia_faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,1).




%%%%%%%%%%%%%%%%%%%%% JE VEUX ETRE CONSEILLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
oh_commencerjeu:- affichePlateau([4,4,4,4,4,4],[4,4,4,4,4,4]), oh_faireJouerJoueur([],[],[4,4,4,4,4,4],[4,4,4,4,4,4],0,0,0).
oh_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl,
													write('Joueur1, à vous de jouer !'), nl,
													affichePlateau(PJ1,PJ2), nl,
													choisiCaseIA(PJ1, PJ2, Y), nl,
													siPremiereDistributionPossible( PJ1, PJ2, Y), nl,

													write('Vous pourriez jouer '), write(Y), write(' par exemple...'), nl,
													write('rentrez le numero de la case que vous voulez jouer'),nl,
													read(X),
													siPremiereDistributionPossible( PJ1, PJ2, X),
													ajoute_element(X, LJ1, NewLJ1),
													tourPlateau(0,PJ1, PJ2, X, NewPJ1, NewPJ2, NBGrainesRamassees, _),
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
													sleep(1),
													\+partiefinie(SCOREJ12,SCOREJ2, NewLJ1, LJ2, PJ1, PJ2),
													renverser(NewPJ1, InvPJ1),
													renverser(NewPJ2, InvPJ2),
													oh_faireJouerJoueur(NewLJ1, LJ2, InvPJ1, InvPJ2, SCOREJ12, SCOREJ2, 1),!.
oh_faireJouerJoueur(LJ1, LJ2,PJ1, PJ2, SCOREJ1, SCOREJ2, 0) :- nl, \+partiefinie(SCOREJ1,SCOREJ2, LJ1, LJ2, PJ1, PJ2),
															write('Votre coup n est pas possible, veuillez rejouer'),
															oh_faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,0).


oh_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl,
												write('L ordinateur joue !'),nl,
												choisiIAfaible(PJ2, PJ1, X),
												siPremiereDistributionPossible( PJ2, PJ1, X),
												ajoute_element(X, LJ2, NewLJ2),
												tourPlateau(0,PJ2, PJ1, X, NewPJ2, NewPJ1, NBGrainesRamassees, _),
												SCOREJ22 is SCOREJ2 + NBGrainesRamassees,
												write('Score joueur 1 :'),
												write(SCOREJ1),
												nl,
												write('Score joueur 2 :'),
												write(SCOREJ22),
												nl,
												sleep(1),
												renverser(NewPJ1, InvPJ1),
												renverser(NewPJ2, InvPJ2),
												\+partiefinie(SCOREJ1,SCOREJ22, LJ1, NewLJ2, PJ1, PJ2),
												oh_faireJouerJoueur(LJ1, NewLJ2, InvPJ1, InvPJ2, SCOREJ1, SCOREJ22, 0).
oh_faireJouerJoueur(LJ1, LJ2, PJ1, PJ2, SCOREJ1, SCOREJ2, 1) :- nl, \+partiefinie(SCOREJ1,SCOREJ2, LJ1, LJ2, PJ1, PJ2),
																write('Votre coup n est pas possible, veuillez rejouer'),
																oh_faireJouerJoueur(LJ1, LJ2, PJ1,PJ2,SCOREJ1,SCOREJ2,1).

																
																
											
