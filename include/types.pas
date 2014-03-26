Type	

	// TYPES RELATIFS AU FONCTIONNEMENT DU DEMINEUR

	// Types simples
	caseType = (empty, mined);				// Sert à savoir si une case contient ou non une mine
	caseStatus = (covered, discovered, flagged, revealed);	// Définit la vision de la case par l'utilisateur
	gameStatus = (running, win, gameOver);
	choiceOptions = (flag, dig, lose, useForce, restart, quit, goToMenu, forceLose);
	minesAround = 0 .. 8;					// Nombre de mines présentes autour de la case actuelle. 
								//Sera affiché sur la carte si la case n'est pas minée.

	// Structures
	smallCase = record					// Le nom case est réservé, donc on utilise smallCase
		cType : caseType;				// Le nom de variable type est réservé par le compilateur ...
								// ... donc on a ajouté un 'c' avant, par ce que c'est rigolo
		cStatus : caseStatus;
		cIsSelected : boolean;
		cMines : minesAround;
		cIsGodCase : boolean;
		cIsNextToGC : boolean;
		cX : integer;
		cY : integer;
	End;

	mapInformations = array of array of smallCase;		// Tableau à 2 dimensions dynamique, pour faire des tableaux de différentes longueurs ...

	playerChoice = record				// Structure contenant la position du curseur du joueur (la case qu'il va jouer)
		posX : integer;
		posY : integer;
		cursorPosX : integer;
		cursorPosY : integer;
		choiceType : choiceOptions;
	End;
	
	timeInformations = record
		secsAtStart : integer;
		secs : integer;
		minsAtStart : integer;
		mins : integer;
		hoursAtStart : integer;
		hours : integer;
		bonus : integer;		// Secondes ajoutées par UseForce
	End;

	displayedStars = record
		x : integer;
		y : integer;
	End;

	gameInformations = record
		map : mapInformations;
		player : playerChoice;
		time : timeInformations;
		currentStatus : gameStatus;
		stars : array of displayedStars;
		horizDim : integer;
		vertDim : integer;
		nbrOfMines : integer;
		//nbrOfDiscoveredMines : integer;
		nbrOfDiscoveredCases : integer;
		isFinished : boolean;
	End;

	ressourcesInformations = record
		hiddenCase, case1, case2, case3, case4, case5, case6, case7, case8, flagImg, timer, mineImg, b2Img, b3Img, b4Img, discoveredCases : gImage;
		font : PTTF_Font;
	End;

	// AUTRES TYPES RELATIFS A LA PRESENTATION GENERALE DU PROGRAMME
	highScoresInformations = record
		names : array[1 .. 11] of string;
		scores : array[1 .. 11] of integer;
		fileStream : TextFile;
	End;

	cursorPosition = record
		x : Uint16;
		y : Uint16;
	End;
	personnalGameParameters = record
		x : integer;
		y : integer;
		minesNbr : integer;
	End;
