// Procédure : useForce
// But : découvrir une case choisie aléatoirement sur le plateau pour aider le joueur
Procedure useForceFunction(var game : gameInformations);
Var i, j : integer;
	mineDiscovered : boolean;
Begin
	mineDiscovered := false;
	game.time.bonus := game.time.bonus + 10;	// On ajoute des points au score final du joueur
	While mineDiscovered <> true do			// On cherche une case éligible
	Begin
		i:=random(game.horizDim);
		j:=random(game.vertDim);
		If (game.map[i][j].cStatus <> discovered) AND (game.map[i][j].cType <> mined) then 
		Begin
			game.player.posX := i;		// On la marque comme choisie manuellement par l'utilisateur
			game.player.posY := j;		// Cela permet d'utiliser ensuite la fonction autoDiscoverCases si besoin est
			game.player.choiceType := dig;
			mineDiscovered := true;
		End;
	End;
End;

// Procédure : audoDiscoverCases
// But découvrir automatiquement les cases vides autour d'une case elle-même vide et sans numéro (vous voyez ce que je veux dire ...)
// Arguments : 
// 	--> 	actualTestedCase, sous forme de structure d'un playerChoice, nous permet d'accéder aux variables de la structure posX et posY
// 		L'utilisation de la structure playerChoice est aussi utile lors de l'appel de la fonction via refreshCases
// 	--> 	game, passé en référence, permet une modification directe du plateau via game.map
Procedure autoDiscoverCases(actualTestedCase : playerChoice; var game : gameInformations);
Var 	newTestedCase : playerChoice;
	i, j : integer;
	endRepeat : boolean;
Begin

	endRepeat := false;
	i := -1;
	j := -1;

	Repeat
		If (actualTestedCase.posX + i >= 0) AND (actualTestedCase.posY + j >= 0) AND (actualTestedCase.posX + i < game.horizDim) AND (actualTestedCase.posY + j < game.vertDim) then	// Si la case ne sort pas du plateau
		Begin
			newTestedCase.posX := actualTestedCase.posX + i;	// On se positionne sur cette case
			newTestedCase.posY := actualTestedCase.posY + j;
			If (game.map[newTestedCase.posX][newTestedCase.posY].cStatus <> discovered) then
			Begin							// Si elle n'est pas découverte
				game.map[newTestedCase.posX][newTestedCase.posY].cStatus := discovered;
				game.nbrOfDiscoveredCases := game.nbrOfDiscoveredCases + 1;
				If game.map[newTestedCase.posX][newTestedCase.posY].cMines = 0 then 	// Si c'est une case vide
					autoDiscoverCases(newTestedCase, game);				// On rappelle la fonction
			End;
		End;

		If (i = -1) AND (j = -1) then j := 0		// Modifie les coordonnées relatives de la case testée à chaque tour de boucle
		Else if (i = -1) AND (j = 0) then j := 1
		Else if (i = -1) AND (j = 1) then i := 0	// D'après nos tests, on me peut pas utiliser de For()
		Else if (i = 0) AND (j = 1) then i := 1
		Else if (i = 1) AND (j = 1) then j := 0
		Else if (i = 1) AND (j = 0) then j := -1
		Else if (i = 1) AND (j = -1) then i := 0
		Else endRepeat := true;

	Until endRepeat = true;
End;

// Fonction : refreshCases
// Objectif : Mettre à jour les différentes cases du tableau et tester si le jeu doit s'arrêter ou non
// Arguments : 	game, contient à la fois le plateau, le choix du joueur, et tout ce qui fait :)
//		Le passage de game en référence nous permet d'agir directement sur la constitution du plateau
// Valeur de retour : gameStatus : détermine si le jeu doit continuer (running), ou s'arrêter (win ou gameOver)
Function refreshCases(var game : gameInformations) : gameStatus;
Begin
	If game.player.choiceType = dig then 		// Si le joueur a choisi de creuser
	Begin
		game.map[game.player.posX][game.player.posY].cStatus := discovered;	// On découvre la case
		game.nbrOfDiscoveredCases := game.nbrOfDiscoveredCases + 1;		// On incrémente le nombre de cases découvertes

		If game.map[game.player.posX][game.player.posY].cMines = 0 then		// Si la case n'est pas adjacente à une mine, alors
			autoDiscoverCases(game.player, game);
											// On lance une récursion pour découvrir les cases vides
		If game.map[game.player.posX][game.player.posY].cType = mined then	// Si on tombe sur une case minée
			refreshCases := gameOver					// On arrête le jeu
		Else
			refreshCases := running;
	End
	Else If game.player.choiceType = flag then	// Sinon si le joueur a choisi de poser/retirer un drapeau
	Begin
		If game.map[game.player.posX][game.player.posY].cStatus = flagged then 	// On inverse le statut de la case
			game.map[game.player.posX][game.player.posY].cStatus := covered

		Else if game.map[game.player.posX][game.player.posY].cStatus = covered then 
			game.map[game.player.posX][game.player.posY].cStatus := flagged;

		refreshCases := running;
	End
	Else if game.player.choiceType = forceLose then refreshCases := gameOver	// Si le joueur a choisi d'abandonner
	Else if game.player.choiceType = useForce then 	// Si le joueur a besoin d'aide
	Begin
		useForceFunction(game);
		refreshCases(game);
		refreshCases := running;
	End;

	If game.nbrOfDiscoveredCases = ((game.horizDim * game.vertDim) - game.nbrOfMines) then	// On teste si toutes les cases non-minées
		refreshCases := win;								// ont étés découvertes
End;

// Procédure : minesweeper
// But : gérer le déroulement complet du jeu, de l'initialisation du plateau à l'écran de fin
// Arguments :
// 	--> 	mimeNb : nombre de mines
// 	--> 	tHoriz et tVert : taille du plateau
// 	--> 	isGUI : si le programme est en console ou en fenêtre
Procedure minesweeper(mineNb : integer ; tHoriz, tVert : integer; isGUI : boolean);
Var 	game : gameInformations;
	hours, mins, secs, mSecs : word;
	minePlaced : boolean;
	a, b, i: integer;
Begin
	game.currentStatus := running;
	game.isFinished := false;
	game.player.posX := 0;
	game.player.posY := 0;
	game.player.cursorPosX := sdl_get_mouse_x;
	game.player.cursorPosY := sdl_get_mouse_y;
	game.horizDim := tHoriz;			// Initialisation des variables de jeu
	game.vertDim := tVert;
	game.nbrOfMines := mineNb;
	game.nbrOfDiscoveredCases := 0;
	game.time.secsAtStart := 0;
	game.time.minsAtStart := 0;
	game.time.hoursAtStart := 0;
	game.time.bonus := 0;

	SetLength(game.map, game.horizDim, game.vertDim);	// On initialise le plateau : tableau de dimension 2
	cleanMap(game);	

	If isGUI then // Si on est en mode GUI, on crée le fenêtre et on crée les étoiles
	Begin
		gClose();
		gInit('Demineur - Star Wars Edition', game.horizDim * 32 + 256, game.vertDim * 32 + 64);
		setLength(game.stars, 500);
		generateStars(game.stars, G_SCR_W, G_SCR_H);
	End;

	Repeat	// On récupère le premier choix du joueur, pour qu'il ne tombe pas sur une mine
		If isGUI then game.player := getPlayerGUIChoice(game)
		Else 	game.player := getPlayerTerminalChoice(game);
	Until game.player.choiceType = dig;	// On bloque le choix du joueur jusqu'à ce qu'il ait choisi une case

	game.map[game.player.posX][game.player.posY].cIsGodCase := true;	// On met cette case en god : pas de mine possible sur celle-ci

	getTime(hours, mins, secs, mSecs);	// On initialise le compteur
	game.time.secsAtStart := secs;
	game.time.minsAtStart := mins;
	game.time.hoursAtStart := hours;

	If (game.player.posX - 1 >= 0) AND (game.player.posY - 1 >= 0) then 	// On met toutes les cases adjacentes à la case god en "isNextToGC"
		game.map[game.player.posX - 1][game.player.posY - 1].cIsNextToGC := true;
	If (game.player.posX - 1 >= 0) AND (game.player.posY + 1 < game.vertDim) then 	// Pas de mies possible sur celles-ci non plus
		game.map[game.player.posX - 1][game.player.posY + 1].cIsNextToGC := true;
	If (game.player.posX + 1 < game.horizDim) AND (game.player.posY - 1 >= 0) then 
		game.map[game.player.posX + 1][game.player.posY - 1].cIsNextToGC := true;
	If (game.player.posX + 1 < game.horizDim) AND (game.player.posY + 1 < game.vertDim) then
		game.map[game.player.posX + 1][game.player.posY + 1].cIsNextToGC := true;
	If game.player.posX - 1 >= 0 then 
		game.map[game.player.posX - 1][game.player.posY].cIsNextToGC := true;
	If game.player.posX + 1 < game.horizDim then 
		game.map[game.player.posX + 1][game.player.posY].cIsNextToGC := true;
	If game.player.posY - 1 >= 0 then 
		game.map[game.player.posX][game.player.posY - 1].cIsNextToGC := true;
	If game.player.posY + 1 < game.vertDim then 
		game.map[game.player.posX][game.player.posY + 1].cIsNextToGC := true;	

	For i := 1 to game.nbrOfMines do	// On génère les mines
	Begin
		minePlaced := false;
		While minePlaced <> true do
		Begin
			a:=random(game.horizDim);
			b:=random(game.vertDim);

			If (game.map[a][b].cType = empty) 	// On teste si la case est éligible
			AND (game.map[a][b].cIsGodCase = false) 
			AND (game.map[a][b].cIsNextToGC = false) then
			Begin
				game.map[a][b].cType := mined;
				If (a - 1 >= 0) AND (b - 1 >= 0) then 	// On incrémente les nombre de mines sur les cases adjacentes
					game.map[a - 1][b - 1].cMines := game.map[a - 1][b - 1].cMines + 1;
				If (a - 1 >= 0) AND (b + 1 < tVert) then // A chaque fois, on teste si on ne sort pas du tableau
					game.map[a - 1][b + 1].cMines := game.map[a - 1][b + 1].cMines + 1;
				If (a + 1 < game.horizDim) AND (b - 1 >= 0) then 
					game.map[a + 1][b - 1].cMines := game.map[a + 1][b - 1].cMines + 1;
				If (a + 1 < game.horizDim) AND (b + 1 < game.vertDim) then
					game.map[a + 1][b + 1].cMines := game.map[a + 1][b + 1].cMines + 1;
				If a - 1 >= 0 then 
					game.map[a - 1][b].cMines := game.map[a - 1][b].cMines + 1;
				If a + 1 < game.horizDim then 
					game.map[a + 1][b].cMines := game.map[a + 1][b].cMines + 1;
				If b - 1 >= 0 then 
					game.map[a][b - 1].cMines := game.map[a][b - 1].cMines + 1;
				If b + 1 < game.vertDim then 
					game.map[a][b + 1].cMines := game.map[a][b + 1].cMines + 1;	
				minePlaced := true;
			End;
		End;
	End;

	game.currentStatus := refreshCases(game); // On peut maintenant valider le choix du joueur

	Repeat	// Boucle de jeu, elle ne s'arrète que lorsque la partie est finie
		If isGUI then game.player := getPlayerGUIChoice(game)
		Else game.player := getPlayerTerminalChoice(game);

		game.currentStatus := refreshCases(game);	// A chaque tour, on rafraichit le plateau

		If (game.currentStatus = gameOver) OR (game.currentStatus = win) then	// Si le jeu est fini
			game.isFinished := true;

	Until game.isFinished = true;

	getFinalScore(game.time); // On arrète le compteur
	If isGUI AND (game.player.choiceType <> forceLose) then endGUIGame(game)	// On lance les fonctions de fin de jeu
	Else if (game.player.choiceType <> forceLose) then endTerminalGame(game);

	If game.player.choiceType = restart then minesweeper(mineNb, tHoriz, tVert, isGUI)
	Else
	Begin
		If isGUI then
		Begin
			gClose();
			gInit('Demineur - Star Wars Edition', 800, 600);
		End
		Else clrscr;
	End;
End;
