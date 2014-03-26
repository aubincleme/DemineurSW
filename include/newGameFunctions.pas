// Procédure : calcParameters
// But : modifier les paramètres de jeu personnalsés de l'utilisateur en fonction de ce qu'il a entré
Procedure calcParameters(var selectedItem : integer; var persoParams : personnalGameParameters; catchedNumber : integer);
Begin
	If selectedItem = 1 then
		If (persoParams.x <= 9) AND (catchedNumber <> -1) then
			persoParams.x := persoParams.x*10 + catchedNumber
		Else persoParams.x := persoParams.x div 10
	Else If selectedItem = 2 then
		If (persoParams.y <= 9) AND (catchedNumber <> -1) then
			persoParams.y := persoParams.y*10 + catchedNumber
		Else persoParams.y := persoParams.y div 10
	Else If selectedItem = 3 then
		If (persoParams.minesNbr <= 9) AND (catchedNumber <> -1) then
			persoParams.minesNbr := persoParams.minesNbr*10 + catchedNumber
		Else persoParams.minesNbr := persoParams.minesNbr div 10;
End;

// Procédure : getPersonnalizedOptions
// Objectif : recueillir les paramètres personnalisés de la grille du démineur graphiquement via la SDL, puis envoyer directement des paramètres dans la fonction minesweeper
// Note importante : cette fonction se base principalement sur la fonction menu() pour son affichage
Procedure getPersonnalizedOptions(var persoParams : personnalGameParameters);
Var 	selectedItem, i : integer;
	settingsOk, return : boolean;
	mainTitle, menuTitle, deathstar, mFalcon : gImage;
	menuItems : array[1 .. 4] of gImage;
	mainFont, titleFont, itemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;
	stars : array of displayedStars;

Begin
	settingsOK := false;	// On initialise les variables de base : validité des paramètres et position du curseur
	return := false;
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;
	persoParams.x := 10;	// Paramètres par défaut
	persoParams.y := 10;
	persoParams.minesNbr := 10;
	selectedItem := 0;

	setLength(stars, 500);	// On génère les étoiles en background
	generateStars(stars, G_SCR_W, G_SCR_H);

	deathstar := gTexLoad('res/deathstar.png');	// On charge les images
	mFalcon := gTexLoad('res/mFalcon.png');

	mainFont := TTF_OpenFont('res/mainFont.ttf', 45);	// On charge les différentes polices
	titleFont := TTF_OpenFont('res/mainFont.ttf', 35);
	itemsFont := TTF_OpenFont('res/mainFont.ttf', 24);

	mainTitle := gTextLoad('demineur -  @  edition', mainFont);	// On définit les éléments de titre
	menuTitle := gTextLoad('--- partie personnalisee ---', titleFont);

	menuItems[4] := gTextLoad('jouer', itemsFont);	
	// Il s'agit d'un élément statique de la fenètre, pas besoin de l'actualiser à chaque boucle

	sdl_update;

	Repeat
		
		// On définit les éléments d'options du menu dynamiques
		menuItems[1] := gTextLoad('largeur de la grille : ' + intToStr(persoParams.x), itemsFont);
		menuItems[2] := gTextLoad('hauteur de la grille : ' + intToStr(persoParams.y), itemsFont);
		menuItems[3] := gTextLoad('nombre de mines : ' + intToStr(persoParams.minesNbr), itemsFont);

		gClear(GUI_BLACK);	// Fond noir

		// On affiche les étoiles
		For i := 0 to length(stars) - 1 do
			gSetPixel(stars[i].x, stars[i].y, GUI_WHITE);

		// On affiche les images
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

		For i := 1 to 4 do	// On effectue un test de présence du curseur sur une des options
		Begin
			If sdl_is_mouse_in(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20) then
			Begin
				// On fait un beau rectangle autour de l'item
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20, GUI_YELLOW);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 14, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 9, menuItems[i]^.w + 28, menuItems[i]^.h + 18, GUI_YELLOW);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 13, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 8, menuItems[i]^.w + 26, menuItems[i]^.h + 16, GUI_YELLOW);

				If sdl_mouse_left_click 				// Si l'utilisateur a cliqué sur l'option 
				AND (originalCursorPosition.x <> sdl_get_mouse_x) 	// ET que la position du curseur est différente 
				AND (originalCursorPosition.y <> sdl_get_mouse_y) then	// de celle en début de procédure, alors ...

					If (i >= 1) AND (i <= 3) then selectedItem := i // On sélectionne l'élément cliqué

					Else if (i = 4) 
					AND (persoParams.x > 5) // On teste si les valeures entrées sont correctes
					AND (persoParams.y > 5) 
					AND (persoParams.minesNbr > 2) 
					AND (persoParams.minesNbr < (persoParams.y * persoParams.x) - 10) then 
					settingsOk := true;	// On arrête la boucle (l'utilisateur a cliqué sur jouer)
			End;
		End;
	
		If selectedItem <> 0 then
		Begin
			gDrawRect(G_SCR_W div 2 - (menuItems[selectedItem]^.w div 2) - 15, (selectedItem+3)*(G_SCR_H div 10) - (menuItems[selectedItem]^.h div 2) - 10, menuItems[selectedItem]^.w + 30, menuItems[selectedItem]^.h + 20, GUI_RED);
			gDrawRect(G_SCR_W div 2 - (menuItems[selectedItem]^.w div 2) - 14, (selectedItem+3)*(G_SCR_H div 10) - (menuItems[selectedItem]^.h div 2) - 9, menuItems[selectedItem]^.w + 28, menuItems[selectedItem]^.h + 18, GUI_RED);
			gDrawRect(G_SCR_W div 2 - (menuItems[selectedItem]^.w div 2) - 13, (selectedItem+3)*(G_SCR_H div 10) - (menuItems[selectedItem]^.h div 2) - 8, menuItems[selectedItem]^.w + 26, menuItems[selectedItem]^.h + 16, GUI_RED);
		End;

		// On va tester si une touche digne d'intéret a été pressée ...
		If sdl_is_keypressed then
		Begin	// Y'A DES KEYCODES BIZZARES
			If (key_up = 27) then 					// Si ECHAP est pressée
				return := true // On quitte la boucle
			Else If (key_up = 8) then 					// Si RETOUR est pressée
				calcParameters(selectedItem,persoParams , -1)

			// On teste successivement les touches du pavé numérique, mais aussi les "touches de saisie numérique"

			Else If (key_up = 257) OR (key_up = 38) then	// Touche 1
				calcParameters(selectedItem, persoParams , 1)
			Else If (key_up = 258) OR (key_up = 233) then 	// Touche 2
				calcParameters(selectedItem, persoParams , 2)
			Else If (key_up = 259) OR (key_up = 34) then 	// Touche 3
				calcParameters(selectedItem, persoParams , 3)
			Else If (key_up = 260) OR (key_up = 39) then 	// Touche 4
				calcParameters(selectedItem, persoParams , 4)
			Else If (key_up = 261) OR (key_up = 40) then 	// Touche 5
				calcParameters(selectedItem, persoParams , 5)
			Else If (key_up = 262) OR (key_up = 45) then 	// Touche 6
				calcParameters(selectedItem, persoParams , 6)
			Else If (key_up = 263) OR (key_up = 232) then 	// Touche 7
				calcParameters(selectedItem, persoParams , 7)
			Else If (key_up = 264) OR (key_up = 95) then 	// Touche 8
				calcParameters(selectedItem, persoParams , 8)
			Else If (key_up = 265) OR (key_up = 231) then 	// Touche 9
				calcParameters(selectedItem, persoParams , 9)
			Else If (key_up = 256) OR (key_up = 224) then 	// Touche 0
				calcParameters(selectedItem, persoParams , 0);
		End;

		gFlip();

		sdl_update;

	Until (settingsOk = true) OR (return = true);

	gTexFree(deathstar);	// On libère les différentes images
	gTexFree(mFalcon);

	If settingsOk then	// Si les paramètres sont les bons (si on a pas appuyé sur ECHAP)
		minesweeper(persoParams.minesNbr, persoParams.x, persoParams.y, true);
End;
