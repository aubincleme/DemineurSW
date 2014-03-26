// Procédure : calcName
// Objectif : ajouter des caractères à un string en fonction des codes de touches de l'utilisateur
// Utilisé dans la fonction getHSName() (définie ci-après)
Procedure calcName(var newHSName : string; keyCode : integer);
Begin
	Case keyCode of
		-1 : Delete(newHSName, Length(newHSName), 1);
		0 : newHSName := newHSName + 'a';
		1 : newHSName := newHSName + 'b';
		2 : newHSName := newHSName + 'c';
		3 : newHSName := newHSName + 'd';
		4 : newHSName := newHSName + 'e';
		5 : newHSName := newHSName + 'f';
		6 : newHSName := newHSName + 'g';
		7 : newHSName := newHSName + 'h';
		8 : newHSName := newHSName + 'i';
		9 : newHSName := newHSName + 'j';
		10 : newHSName := newHSName + 'k';
		11 : newHSName := newHSName + 'l';
		12 : newHSName := newHSName + 'm';
		13 : newHSName := newHSName + 'n';
		14 : newHSName := newHSName + 'o';
		15 : newHSName := newHSName + 'p';
		16 : newHSName := newHSName + 'q';
		17 : newHSName := newHSName + 'r';
		18 : newHSName := newHSName + 's';
		19 : newHSName := newHSName + 't';
		20 : newHSName := newHSName + 'u';
		21 : newHSName := newHSName + 'v';
		22 : newHSName := newHSName + 'w';
		23 : newHSName := newHSName + 'x';
		24 : newHSName := newHSName + 'y';
		25 : newHSName := newHSName + 'z';
	End;
End;

// Fonction : getHSName()
// Objectif : récupérer le nom du gagnant de la partie dans une interface graphique
Function getHSName(game : gameInformations; score : integer) : string;
Var	validateHS : boolean;
	newHSName : string;
	i : integer;
	mainTitle, menuTitle, deathstar, mFalcon : gImage;
	menuItems : array[1 .. 4] of gImage;
	mainFont, titleFont, itemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;
	stars : array of displayedStars;

Begin
	validateHS := false;	// On initialise les variables de base : validité des paramètres et position du curseur
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;
	setLength(stars, 500);
	generateStars(stars, G_SCR_W, G_SCR_H);
	newHSName := '';

	deathstar := gTexLoad('res/deathstar.png');
	mFalcon := gTexLoad('res/mFalcon.png');

	mainFont := TTF_OpenFont('res/mainFont.ttf', 45);	// On charge les différentes polices
	titleFont := TTF_OpenFont('res/mainFont.ttf', 35);
	itemsFont := TTF_OpenFont('res/mainFont.ttf', 24);

	mainTitle := gTextLoad('demineur -  @  edition', mainFont);	// On définit les éléments de titre
	menuTitle := gTextLoad('--- partie terminee ---', titleFont);

	menuItems[1] := gTextLoad('score total : ' + intToStr(score), itemsFont);
	menuItems[2] := gTextLoad('vous etes dans les meilleurs scores', itemsFont);
	menuItems[4] := gTextLoad('valider', itemsFont);

	sdl_update;

	Repeat
		menuItems[3] := gTextLoad('pseudo : ' + newHSName, itemsFont);

		gClear(GUI_BLACK);	// Fond noir

		For i := 0 to length(stars) - 1 do
			gSetPixel(stars[i].x, stars[i].y, GUI_WHITE);

		gDraw(0, 150, mFalcon);

		gDraw(G_SCR_W - 150, G_SCR_H - 150, deathstar);

		gBeginRects(mainTitle);					// On affiche le titre principal
          		gSetCoordMode(G_CENTER);
          		gSetCoord(G_SCR_W div 2, 1*(G_SCR_H div 12));
            		gSetColor(GUI_YELLOW);
          		gAdd();
		gEnd();
			gBeginRects(menuTitle);				// On affiche le titre du menu
        		gSetCoordMode(G_CENTER);
        		gSetCoord(G_SCR_W div 2, 3*(G_SCR_H div 12));
        		gSetColor(GUI_YELLOW);
        		gAdd();
        	gEnd();

		For i := 1 to 4 do
		Begin
        		gBeginRects(menuItems[i]);			// On affiche tous les éléments d'option
        	   		gSetCoordMode(G_CENTER);
        	    		gSetCoord(G_SCR_W div 2, (i+3)*(G_SCR_H div 10));
        	    		gSetColor(GUI_YELLOW);
        	    		gAdd();
        		gEnd();
		End;

		If sdl_is_mouse_in(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (7)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20) then
		Begin
				// On fait un beau rectangle autour de l'item
			gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (7)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20, GUI_YELLOW);
			gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 14, (7)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 9, menuItems[i]^.w + 28, menuItems[i]^.h + 18, GUI_YELLOW);
			gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 13, (7)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 8, menuItems[i]^.w + 26, menuItems[i]^.h + 16, GUI_YELLOW);

			If sdl_mouse_left_click AND (originalCursorPosition.x <> sdl_get_mouse_x) AND (originalCursorPosition.y <> sdl_get_mouse_y) then
				validateHS := true;
		End;

		// On va tester si une touche digne d'intéret a été pressée ...
		If sdl_is_keypressed AND not keypressed then
		Begin	// Y'A DES KEYCODES BIZZARES

			Case key_up of
				8 : calcName(newHSName, -1);		// TOUCHE RETOUR
				97 : calcName(newHSName, 0); 		// TOUCHE A
				98 : calcName(newHSName, 1);		// TOUCHE B
				99 : calcName(newHSName, 2);		// TOUCHE C
				100 : calcName(newHSName, 3);		// ... vous avez compris, non ?
				101 : calcName(newHSName, 4);
				102 : calcName(newHSName, 5);
				103 : calcName(newHSName, 6);
				104 : calcName(newHSName, 7);
				105 : calcName(newHSName, 8);
				106 : calcName(newHSName, 9);
				107 : calcName(newHSName, 10);
				108 : calcName(newHSName, 11);
				109 : calcName(newHSName, 12);
				110 : calcName(newHSName, 13);
				111 : calcName(newHSName, 14);
				112 : calcName(newHSName, 15);
				113 : calcName(newHSName, 16);
				114 : calcName(newHSName, 17);
				115 : calcName(newHSName, 18);
				116 : calcName(newHSName, 19);
				117 : calcName(newHSName, 20);
				118 : calcName(newHSName, 21);
				119 : calcName(newHSName, 22);
				120 : calcName(newHSName, 23);
				121 : calcName(newHSName, 24);
				122 : calcName(newHSName, 25);
			End;
		End;

		gFlip();
		sdl_update;

	Until (validateHS = true);

	gTexFree(deathstar);	// On libère les différentes images
	gTexFree(mFalcon);

	getHSName := newHSName;
End;

// Procédure : endGUIGame
// But : superviser la fin du jeu en GUI
Procedure endGUIGame(var game : gameInformations);
Var 	i, HSPosition, score : integer;
	choiceOk, isOkForHS : boolean;
	newHSName : string;
	ressources : ressourcesInformations;
	HSFile : highScoresInformations;
	choice : playerChoice;
Begin
	choice.cursorPosX := game.player.cursorPosX;
	choice.cursorPosY := game.player.cursorPosY;
	isOkForHS := false;
	discoverMines(game);	// On découvre les mines sur le plateau
	score := game.time.hours*3600 + game.time.mins*60 + game.time.secs + game.time.bonus;	// On calcule le score

	ressources.font := TTF_OpenFont('res/mainFont.ttf', 25);
	ressources.hiddenCase := gTexLoad('res/hiddenCase.png');
	ressources.mineImg := gTexLoad('res/smallDeathstar.png');
	ressources.case1 := gTexLoad('res/1.png');
	ressources.case2 := gTexLoad('res/2.png');
	ressources.case3 := gTexLoad('res/3.png');
	ressources.case4 := gTexLoad('res/4.png');
	ressources.case5 := gTexLoad('res/5.png');
	ressources.case6 := gTexLoad('res/6.png');
	ressources.case7 := gTexLoad('res/7.png');
	ressources.case8 := gTexLoad('res/8.png');
	ressources.flagImg := gTexLoad('res/flag.png');

	ressources.b2Img := gTextLoad('Recommencer', ressources.font);
	ressources.b3Img := gTextLoad('Retourner', ressources.font);
	ressources.b4Img := gTextLoad('au menu', ressources.font);

	If game.currentStatus = win then	// Petit titre personnalisé
		ressources.discoveredCases := gTextLoad('gagne !', ressources.font)
	Else ressources.discoveredCases := gTextLoad('perdu !', ressources.font);

	choiceOk := false;

	Repeat
		displayGUIMap(ressources, game, score);
		If sdl_is_mouse_in(0, 64, 256, (G_SCR_H - 64) div 2) then // Test de présence du curseur sur les différents boutons
		Begin
			gDrawRect(1, 65, 254, ((G_SCR_H - 64) div 2) - 1, GUI_YELLOW);
			gDrawRect(2, 66, 253, ((G_SCR_H - 64) div 2) - 2, GUI_YELLOW);
			gDrawRect(2, 66, 253, ((G_SCR_H - 64) div 2) - 3, GUI_YELLOW);
		End
		Else If sdl_is_mouse_in(0, 64 + 2 * ((G_SCR_H - 64) div 4), 256, (G_SCR_H - 64) div 2) then
		Begin
			gDrawRect(1, 65 + 2 * ((G_SCR_H - 64) div 4), 254, ((G_SCR_H - 64) div 2) - 1, GUI_YELLOW);
			gDrawRect(1, 65 + 2 * ((G_SCR_H - 64) div 4), 254, ((G_SCR_H - 64) div 2) - 2, GUI_YELLOW);
			gDrawRect(2, 66 + 2 * ((G_SCR_H - 64) div 4), 253, ((G_SCR_H - 64) div 2) - 3, GUI_YELLOW);
		End;

		If sdl_mouse_left_click	// Si on a cliqué sur un bouton
		AND (choice.cursorPosX <> sdl_get_mouse_x) AND (choice.cursorPosY <> sdl_get_mouse_y)  
		AND (sdl_get_mouse_x < G_SCR_W) AND (sdl_get_mouse_y < G_SCR_H) then
		Begin
			If sdl_is_mouse_in(0, 64, 256, (G_SCR_H - 64) div 2) then
			Begin
				choiceOk := true;
				choice.cursorPosX := sdl_get_mouse_x;
				choice.cursorPosY := sdl_get_mouse_y;
				choice.choiceType := restart;
			End
			Else if sdl_is_mouse_in(0, 64 + 2 * ((G_SCR_H - 64) div 4), 256, (G_SCR_H - 64) div 2) then
			Begin
				choiceOk := true;
				choice.cursorPosX := sdl_get_mouse_x;
				choice.cursorPosY := sdl_get_mouse_y;
				choice.choiceType := goToMenu;
			End;
		End;
		gFlip();
		sdl_update;
	Until choiceOk = true;

	If game.currentStatus = win then	// Si le joueur a gagné, on teste si il est élégible pour les meilleurs scores
	Begin
		HSFile := readHighScoresFile();

		For i := 10 downto 1 do
		Begin
			If (i = 1) AND (HSFile.scores[i] > score) then
			Begin
				isOkForHS := true;
				HSPosition := 1;
			End
			Else If (HSFile.scores[i] > score) AND (HSFile.scores[i - 1] < score) then // BUG ICI
			Begin
				isOkForHS := true;
				HSPosition := i;
			End;
		End;

		If isOkForHS then	// Si c'est le cas ....
		Begin	
			gClose();	// On adapte la fenètre à nos besoins
			gInit('Demineur - Star Wars Edition', 800, 600);
			newHSName := getHSName(game, score);	// On récupère le pseudo du joueur
			appendHighScore(HSFile, score, newHSName, HSPosition);
			gClose();	// On rétablit la fenètre d'origine
			gInit('Demineur - Star Wars Edition', game.horizDim * 32 + 256, game.vertDim * 32 + 64);
		End;
	End;

	game.player.choiceType := choice.choiceType;	// Et on modifie le choix du joueur selon la sélection de ce dernier
End;

// Procédure : endTerminalGame
// But : gérer la fin d'une partie en mode console
Procedure endTerminalGame(game : gameInformations);
Var 	isOkForHS : boolean;
	i, HSPosition, score : integer;
	newHSName : string;
	HSFile : highScoresInformations;
Begin

	If game.currentStatus = win then	// On teste si le joueur est éligible aux meilleurs scores
	Begin
		score := game.time.hours*3600 + game.time.mins*60 + game.time.secs + game.time.bonus;
		HSFile := readHighScoresFile();

		For i := 10 downto 1 do
		Begin
			If (i = 1) AND (HSFile.scores[i] > score) then
			Begin
				isOkForHS := true;
				HSPosition := 1;
			End
			Else If (HSFile.scores[i] > score) AND (HSFile.scores[i - 1] < score) then // BUG ICI
			Begin
				isOkForHS := true;
				HSPosition := i;
			End;
		End;
	End;

	discoverMines(game);	// On découvre les mines
	game.map[game.player.posX][game.player.posY].cIsSelected := false;
	clrscr;
	displayTerminalMap(game);	// On affiche le plateau ainsi découvert
	writeLn('');
	writeLn('JEU TERMINE !');

	If game.currentStatus = win then	// Le joueur a gagné ...
	Begin
		writeLn('Merci d''avoir joué, vôtre score final est de : ', score);
		writeLn('');
	
		If isOkForHS then
		Begin
			writeLn('Félicitations ! Vous faites partie des meilleurs scores !');
			write('Entrez vôtre nom pour sauvegarder le score : ');
			readLn(newHSName);
			appendHighScore(HSFile, score, newHSName, HSPosition);
			writeLn('');
			writeLn('Score sauvegardé !');
		End;
	End;
	
	writeLn('Appuyez sur ENTREE pour continuer ...');
	readLn;
End;
