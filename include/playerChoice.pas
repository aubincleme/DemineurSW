// Fonction : getPlayerGUIChoice
// Objectif : récupérer la sélection d'un joueur en affichant le plateau comportant un sélecteur
// Arguments : 	lastPlayerInput : contient les coordonnées du dernier choix de l'utilisateur, utile pour placer le sélecteur
//		map : plateau de jeu
//		tHoriz, tVert : dimensions du plateau de jeu
Function getPlayerGUIChoice(var game : gameInformations) : playerChoice;
Var	ressources : ressourcesInformations;
	choiceOk : boolean;	// Permet de sortir de la boucle de sélection Repeat ... Until
	choice : playerChoice;	// Structure contenant :
				//	choice.posX et choice.posY : addresse de la sélection du joueur
				//	choice.choiceType : type d'action à exécuter : dig, flag, save, useForce ou lose
Begin
	choice.posX := game.player.posX;	// On affecte eu curseur de sélection la dernière adresse choisie par l'utilisateur
	choice.posY := game.player.posY;
	choice.cursorPosX := game.player.cursorPosX;
	choice.cursorPosY := game.player.cursorPosY;
	choiceOk := false;			// Pour éviter de sortir directement de la boucle ...

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

	ressources.b2Img := gTextLoad('abandonner', ressources.font);
	ressources.b3Img := gTextLoad('utiliser', ressources.font);
	ressources.b4Img := gTextLoad('la force', ressources.font);

	ressources.discoveredCases := gTextLoad(intToStr(game.nbrOfDiscoveredCases) + ' / ' + intToStr((game.horizDim * game.vertDim) - game.nbrOfMines), ressources.font);

	Repeat
		game.map[choice.posX][choice.posY].cIsSelected := true;	// On active la variable cIsSelected pour afficher le curseur

		displayGUIMap(ressources, game, 0);	// Affichage de la MAP

		If (sdl_get_mouse_x > 256) AND (sdl_get_mouse_y > 64) // On teste si le curseur est sur une case non sélectionnée
		AND (sdl_get_mouse_x < G_SCR_W) AND (sdl_get_mouse_y < G_SCR_H) then
		Begin
			game.map[choice.posX][choice.posY].cIsSelected := false;
			game.map[((sdl_get_mouse_x - 256) div 32)][((sdl_get_mouse_y - 64) div 32)].cIsSelected := true;
			choice.posX := ((sdl_get_mouse_x - 256) div 32);
			choice.posY := ((sdl_get_mouse_y - 64) div 32);
		End;

		If sdl_is_mouse_in(0, 64, 256, (G_SCR_H - 64) div 2) then	// On teste si le curseur est sur un bouton
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

		If sdl_mouse_left_click
		AND (choice.cursorPosX <> sdl_get_mouse_x) AND (choice.cursorPosY <> sdl_get_mouse_y)  
		AND (sdl_get_mouse_x < G_SCR_W) AND (sdl_get_mouse_y < G_SCR_H) then
		Begin
	
			If (sdl_get_mouse_x > 256) AND (sdl_get_mouse_y > 64) then
			Begin 
				If game.map[((sdl_get_mouse_x - 256) div 32)][((sdl_get_mouse_y - 64) div 32)].cStatus = covered then
				Begin
					choiceOk := true;	// On arrête la boucle
					choice.cursorPosX := sdl_get_mouse_x;
					choice.cursorPosY := sdl_get_mouse_y;
					choice.posX := ((sdl_get_mouse_x - 256) div 32);
					choice.posY := ((sdl_get_mouse_y - 64) div 32);
					choice.choiceType := dig;
				End;
					
			End
			Else if sdl_is_mouse_in(0, 64, 256, (G_SCR_H - 64) div 2) then
			Begin
				choiceOk := true;
				choice.choiceType := forceLose;
			End
			Else if sdl_is_mouse_in(0, 64 + 2 * ((G_SCR_H - 64) div 4), 256, (G_SCR_H - 64) div 2) then
			Begin
				choiceOk := true;
				choice.cursorPosX := sdl_get_mouse_x;
				choice.cursorPosY := sdl_get_mouse_y;
				choice.choiceType := useForce;
			End;
		End;

		If sdl_mouse_right_click 	// On teste si le curseur est sur une case flaggable et si le clic droit est pressé
		AND (sdl_get_mouse_x > 256) AND (sdl_get_mouse_y > 64) 
		AND (choice.cursorPosX <> sdl_get_mouse_x) AND (choice.cursorPosY <> sdl_get_mouse_y)  
		AND (sdl_get_mouse_x < G_SCR_W) AND (sdl_get_mouse_y < G_SCR_H) then
		Begin
			choiceOk := true;	// On arrête la boucle
			choice.cursorPosX := sdl_get_mouse_x;
			choice.cursorPosY := sdl_get_mouse_y;
			choice.posX := ((sdl_get_mouse_x - 256) div 32);
			choice.posY := ((sdl_get_mouse_y - 64) div 32);
			choice.choiceType := flag;
		End;

		gFlip();
		sdl_update;

	Until choiceOk = true;

	getPlayerGUIChoice := choice;
End;

// Fonction : getPlayerTerminalChoice
// Objectif : récupérer la sélection d'un joueur en affichant le plateau comportant un sélecteur
// Arguments : 	lastPlayerInput : contient les coordonnées du dernier choix de l'utilisateur, utile pour placer le sélecteur
//		map : plateau de jeu
//		tHoriz, tVert : dimensions du plateau de jeu
Function getPlayerTerminalChoice(var game : gameInformations) : playerChoice;
Var	choiceOk : boolean;	// Permet de sortir de la boucle de sélection Repeat ... Until, passe en TRUE si une des touches reconnues est pressée
	choice : playerChoice;	// Structure contenant :
				//	choice.posX et choice.posY : addresse de la sélection du joueur
				//	choice.choiceType : type d'action à exécuter : dig ou flag
	keyPressed : char;	// Contient le code ASCII du caractère pressé
Begin
	choice.posX := game.player.posX;	// On affecte eu curseur de sélection la dernière adresse choisie par l'utilisateur
	choice.posY := game.player.posY;
	choiceOk := false;			// Pour éviter de sortir directement de la boucle ...

	Repeat
		game.map[choice.posX][choice.posY].cIsSelected := true;		// On active la variable cIsSelected pour afficher le curseur
		clrscr;
		displayTerminalMap(game);	// On affiche le plateau
		writeLn('******************************');
		writeLn('Se diriger : HAUT, BAS, GAUCHE, DROITE');
		writeLn('Creuser : ENTREE, poser un drapeau : F, obtenir une aide : H, abandonner : L');

		keyPressed := ReadKey;
		game.map[choice.posX][choice.posY].cIsSelected := false;	// On désactive la variable cIsSelected
		If (keyPressed = #13) AND (game.map[choice.posX][choice.posY].cStatus <> flagged) then // La touche ENTREE est pressée
		Begin
			choiceOk := true;
			choice.choiceType := dig;
		End
		Else If keyPressed = #102 then // La touche F est pressée
		Begin
			choiceOk := true;
			choice.choiceType := flag;
		End
		Else If keyPressed = #104 then // La touche H est pressée
		Begin
			choiceOk := true;
			choice.choiceType := useForce;
		End
		Else If keyPressed = #108 then // La touche L est pressée
		Begin
			choiceOk := true;
			choice.choiceType := lose;
		End
		Else if keyPressed = #0 then // Caractère étendu
		Begin
			keyPressed := ReadKey; // Obligatoire pour obtenir les codes des touches HAUT, BAS, GAUCHE et DROITE
			If keyPressed = #72 then // La touche HAUT est pressée
			Begin
				If choice.posY = 0 then choice.posY := game.vertDim - 1
				Else choice.posY := choice.posY - 1;
			End
			Else If keyPressed = #75 then // La touche GAUCHE est pressée
			Begin
				If choice.posX = 0 then choice.posX := game.horizDim - 1
				Else choice.posX := choice.posX - 1;
			End
			Else if keyPressed = #77 then // La touche DROITE est pressée
			Begin
				If choice.posX = game.horizDim - 1 then choice.posX := 0
				Else choice.posX := choice.posX + 1;
			End
			Else if keyPressed = #80 then // La touche BAS est pressée
			Begin
				If choice.posY = game.vertDim - 1 then choice.posY := 0
				Else choice.posY := choice.posY + 1;
			End;
		End;
	Until choiceOk = true;

	TextColor(Black);
	getPlayerTerminalChoice := choice;
End;
