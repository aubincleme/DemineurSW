// Procédure : displayHighScores
// But : afficher les meilleurs scores du jeu depuis le menu principal
Procedure displayHighScores(isGUI : boolean);
Var HSFile : highScoresInformations;
	i : integer;
	return : boolean;
	mainTitle, HSTitle, deathstar, mFalcon : gImage;	// Les éléments de base
	HSItems : array[1 .. 11] of gImage;
	mainFont, titleFont, itemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;
	stars : array of displayedStars;
Begin

	HSFile := readHighscoresFile();
	
	If isGUI then	// Version GUI
	Begin
		return := false;
		originalCursorPosition.x := sdl_get_mouse_x;
		originalCursorPosition.y := sdl_get_mouse_y;
		setLength(stars, 500);
		generateStars(stars, G_SCR_W, G_SCR_H);

		deathstar := gTexLoad('res/deathstar.png');
		mFalcon := gTexLoad('res/mFalcon.png');

		mainFont := TTF_OpenFont('res/mainFont.ttf', 45);	// On charge les différentes polices
		titleFont := TTF_OpenFont('res/mainFont.ttf', 35);
		itemsFont := TTF_OpenFont('res/mainFont.ttf', 17);

		mainTitle := gTextLoad('demineur -  @  edition', mainFont);	// On définit les éléments de titre
		HSTitle := gTextLoad('--- meilleurs scores ---', titleFont);

		For i := 1 to 10 do
			HSItems[i] := gTextLoad(intToStr(i) + ' : ' + HSFile.names[i] + ' - ' + intToStr(HSFile.scores[i]), itemsFont);

		HSItems[11] := gTextLoad('Retour au menu principal', itemsFont);

		sdl_update;

		Repeat
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
				gBeginRects(HSTitle);				// On affiche le titre du menu
        			gSetCoordMode(G_CENTER);
        			gSetCoord(G_SCR_W div 2, 2*(G_SCR_H div 12));
				gSetColor(GUI_YELLOW);
				gAdd();
			gEnd();

			For i := 1 to 11 do
			Begin
				gBeginRects(HSItems[i]);
			   		gSetCoordMode(G_CENTER);
			    		gSetCoord(G_SCR_W div 2, (i+4)*((G_SCR_H - 3*(G_SCR_H div 12)) div 14));
			    		gSetColor(GUI_YELLOW);
			    		gAdd();
				gEnd();
			End;

			If sdl_is_mouse_in(G_SCR_W div 2 - (HSItems[11]^.w div 2) - 15, (15)*((G_SCR_H - 3*(G_SCR_H div 12)) div 14) - (HSItems[11]^.h div 2) - 10, HSItems[11]^.w + 30, HSItems[11]^.h + 20) then
			Begin
				// On fait un beau rectangle autour de l'item
				gDrawRect(G_SCR_W div 2 - (HSItems[11]^.w div 2) - 15, (15)*((G_SCR_H - 3*(G_SCR_H div 12)) div 14) - (HSItems[11]^.h div 2) - 10, HSItems[11]^.w + 30, HSItems[i]^.h + 20, GUI_YELLOW);
				gDrawRect(G_SCR_W div 2 - (HSItems[11]^.w div 2) - 14, (15)*((G_SCR_H - 3*(G_SCR_H div 12)) div 14) - (HSItems[11]^.h div 2) - 9, HSItems[11]^.w + 28, HSItems[i]^.h + 18, GUI_YELLOW);
				gDrawRect(G_SCR_W div 2 - (HSItems[11]^.w div 2) - 13, (15)*((G_SCR_H - 3*(G_SCR_H div 12)) div 14) - (HSItems[11]^.h div 2) - 8, HSItems[11]^.w + 26, HSItems[i]^.h + 16, GUI_YELLOW);
				If sdl_mouse_left_click AND (originalCursorPosition.x <> sdl_get_mouse_x) AND (originalCursorPosition.y <> sdl_get_mouse_y) then
					return := true;	// On arrête la boucle
			End;

			If sdl_is_keypressed AND (sdl_get_keypressed = 27) then			// Si ECHAP est pressée
				return := true; // On quitte la boucle

			gFlip();

			sdl_update;

		Until return = true;

		gTexFree(deathstar);	// On libère les différentes images
		gTexFree(mFalcon);
	End
	Else		// Version Console
	Begin	
		clrscr;
		writeln('*************************');
		writeLn('       HIGHSCORES        ');
		writeLn('*************************');

		For i := 1 to 10 do 
			writeln(i, ' : ', HSFile.names[i], ' - ', HSFile.scores[i]);

		Writeln('');
		write('Appuyez sur ENTREE pour revenir au menu principal ');
		ReadLn;
	End;
End;
