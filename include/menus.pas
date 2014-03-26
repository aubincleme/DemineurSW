// Fonction : menu
// Objectif : afficher un beau menu en fonction des options de celui-ci passées en paramètre
// Paramètres :
//		--> 1 : Tableau 'option' dynamique, contient les différents choix possibles pour le menu
//		--> 2 : Chaine de caractères 'menuTitle', définit le titre du menu

Function menuTerminal(option : array of string; menuTitle : string) : integer;

Var choice, i, actualOption : integer;
	keyPressed : char;

Begin

	choice := 42;
	actualOption := 0;
	TextColor(white);
	Repeat
			clrscr; // Pour une présentation plus soignée :) !
			writeln('********************************************************************************************************************************');
			writeln('*  ______ ________  ________ _   _  _____ _   _______           ______     _                  _____    _ _ _   _               *');
			writeln('*  |  _  \  ___|  \/  |_   _| \ | ||  ___| | | | ___ \          |  _  \   | |                |  ___|  | (_) | (_)              *');
			writeln('*  | | | | |__ | .  . | | | |  \| || |__ | | | | |_/ /  ______  | | | |___| |_   ___  _____  | |__  __| |_| |_ _  ___  _ __    *');
			writeln('*  | | | |  __|| |\/| | | | | . '' ||  __|| | | |    /  |______| | | | / _ \ | | | \ \/ / _ \ |  __|/ _'' | | __| |/ _ \| ''_ \   *');
			writeln('*  | |/ /| |___| |  | |_| |_| |\  || |___| |_| | |\ \           | |/ /  __/ | |_| |>  <  __/ | |__| (_| | | |_| | (_) | | | |  *');
			writeln('*  |___/ \____/\_|  |_/\___/\_| \_/\____/ \___/\_| \_|          |___/ \___|_|\__,_/_/\_\___| \____/\__,_|_|\__|_|\___/|_| |_|  *');
			writeln('*                                                                                                                              *');
			writeln('********************************************************************************************************************************');
			writeln('');
			writeln(' ----- ' + menuTitle + ' ----- ');
			
			For i := 0 to length(option) do // On affiche ligne par ligne les différentes options du menu
			Begin
				If actualOption = i then
				Begin
					TextBackground(White);
					TextColor(Black);
					writeln('--> ' + option[i]);
					TextBackground(Black);
					TextColor(White);
				End
				Else
					writeln('    ' + option[i]);
			End;
			
			keyPressed := ReadKey;
			If keyPressed = #13 then // La touche ENTREE est pressée
				choice := actualOption + 1 // Le premier choix prend la valeur 1, et non pas la valeur 0 (comme c'est le cas pour le tableau option, dynamique)
			Else if keyPressed = #0 then // Caractère étendu
			Begin
				keyPressed := ReadKey; // Obligatoire pour obtenir les codes des touches HAUT et BAS
				If keyPressed = #72 then // La touche HAUT est pressée
				Begin
					If actualOption = 0 then actualOption := length(option) - 1 // Si on est au début de la liste de choix
					Else actualOption := actualOption - 1;
				End
				Else if keyPressed = #80 then // La touche BAS est pressée
				Begin
					If actualOption = length(option) - 1 then actualOption := 0
					Else actualOption := actualOption + 1;
				End
			End
			
	Until (choice >= 1) AND (choice <= length(option));
	
	menuTerminal := choice;
END;

// Fonction : menuGUI
// Objectif : afficher un beau menu en fonction des options de celui-ci passées en paramètre
// Paramètres :
//		--> 1 : Tableau 'menuItemsStrings' dynamique, contient les différents choix possibles pour le menu
//		--> 2 : Chaine de caractères 'menuTitle', définit le titre du menu
// Précondition : 
// Pour éviter un affichage moche et des bugs d'affichage divers, le tableau 'menuItemsStrings' ne doit pas comporter plus de 6 choix
// Information importante :
// La fonction renvoie 0 si la touche ECHAP est pressée, sinon, la fonction renvoie la position du choix dans le tableau + 1

Function menuGUI(menuItemsStrings : array of string; menuTitleString : string) : integer;

{$I 'include/const.pas'}

Var 	nbrOfItems, choice, i : integer;
	choiceOk : boolean;
	mainTitle, menuTitle, deathstar, mFalcon : gImage;
	menuItems : array of gImage;
	mainFont, menuTitleFont, menuItemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;
	stars : array of displayedStars;

Begin
	choiceOK := false;	// On initialise les variables de base : choix et position du curseur
	choice := 0;
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;
	setLength(stars, 500);
	generateStars(stars, G_SCR_W, G_SCR_H);

	deathstar := gTexLoad('res/deathstar.png');
	mFalcon := gTexLoad('res/mFalcon.png');

	mainFont := TTF_OpenFont('res/mainFont.ttf', 45);	// On charge les différentes polices
	menuTitleFont := TTF_OpenFont('res/mainFont.ttf', 35);
	menuItemsFont := TTF_OpenFont('res/mainFont.ttf', 24);

	nbrOfItems := length(menuItemsStrings);	// On coordonne la taille du tableau contanant les éléments affichés avec celle du tableau d'options donnée en paramètre
	setLength(menuItems, nbrOfItems);

	mainTitle := gTextLoad('demineur -  @  edition', mainFont);	// On définit les éléments de titre
	menuTitle := gTextLoad('--- ' + menuTitleString + ' ---', menuTitleFont);

	For i := 0 to nbrOfItems - 1 do	// On définit les éléments d'options du menu
		menuItems[i] := gTextLoad(menuItemsStrings[i], menuItemsFont);

	sdl_update;

	Repeat
		gClear(GUI_BLACK);	// Fond noir

		For i := 0 to length(stars) - 1 do
			gSetPixel(stars[i].x, stars[i].y, GUI_WHITE);

		gDraw(0, 150, mFalcon);

		gDraw(G_SCR_W - 150, G_SCR_H - 150, deathstar);

		gBeginRects(mainTitle);	// On affiche le titre principal
          		gSetCoordMode(G_CENTER);
          		gSetCoord(G_SCR_W div 2, 1*(G_SCR_H div 12));
            		gSetColor(GUI_YELLOW);
          		gAdd();
		gEnd();
			gBeginRects(menuTitle);	// On affiche le titre du menu
        		gSetCoordMode(G_CENTER);
        		gSetCoord(G_SCR_W div 2, 3*(G_SCR_H div 12));
        		gSetColor(GUI_YELLOW);
        		gAdd();
        	gEnd();

		For i := 0 to nbrOfItems - 1 do
		Begin
        		gBeginRects(menuItems[i]);	// On affiche tous les éléments d'option
        	   		gSetCoordMode(G_CENTER);
        	    		gSetCoord(G_SCR_W div 2, (i+4)*(G_SCR_H div 10)); // Attention : si la précondition n'est pas respectée, c'est ici que ça peut bugger.
        	    		gSetColor(GUI_YELLOW);
        	    		gAdd();
        		gEnd();
		End;

		For i := 0 to nbrOfItems - 1 do	// On effectue un test de présence du curseur sur une des options
		Begin
			If sdl_is_mouse_in(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20) then
			Begin
				choice := i;
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20, GUI_YELLOW);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 14, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 9, menuItems[i]^.w + 28, menuItems[i]^.h + 18, GUI_YELLOW);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 13, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 8, menuItems[i]^.w + 26, menuItems[i]^.h + 16, GUI_YELLOW);
				If sdl_mouse_left_click AND (originalCursorPosition.x <> sdl_get_mouse_x) AND (originalCursorPosition.y <> sdl_get_mouse_y) then	// Si l'utilisateur a cliqué sur l'option ET que la position du curseur est différente de celle en début de boucle, alors ...
				Begin
					choiceOk := true;	// On arrête la boucle
					choice := 1 + i;	// On renvoie le choix (entre 1 et le nombre de cases du tableau)
				End;
			End;
		End;

		If sdl_is_keypressed then 
		Begin
			If sdl_get_keypressed = 27 then 	// Si ECHAP est pressée
			Begin
				choice := 0;
				choiceOk := true;
			End;
		End;

		gFlip();

		sdl_update;

	Until choiceOk = true;

	gTexFree(deathstar);	// On libère les différentes images
	gTexFree(mFalcon);

	menuGUI := choice;
End;
