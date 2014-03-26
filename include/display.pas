// Procédure : generateStars 
// But : générer un fond étoilé dans la version graphique du démineur
// La position des étoiles est aléatoire
Procedure generateStars(var stars : array of displayedStars; xMax, yMax : integer);
Var	i : integer;
Begin
	For i := 0 to length(stars) - 1 do
	Begin
		stars[i].x := random(xMax) - 1;
		stars[i].y := random(yMax) - 1;
	End;
End;

// Procédure : displayGUIMap
// But : afficher la fenêtre de jeu en mode graphique
// Arguments : 
// 	--> 	L'utilisation d'une structure ressourceInformations passée en argument 
//		nous permet de ne pas recharger toutes les images du plateau à chaque rafraichissement d'interface
//	--> 	La structure gameInformations conserve les informations à afficher (cases découvertes, case sélectionnée, etc ...)
// 	--> 	Le score n'est affiché que si il n'est pas nul (càd, lorsque le jeu est fini)
Procedure displayGUIMap(rc : ressourcesInformations; game : gameInformations; score : integer);
Var i, j : integer;
Begin
	gClear(GUI_BLACK);	// Fond noir
	For i := 0 to length(game.stars) - 1 do		// On affiche les étoiles (très important)
		gSetPixel(game.stars[i].x, game.stars[i].y, GUI_WHITE);

	gDrawRect(0, 0, 256, 64, GUI_YELLOW);	// Rectangle entourant le timer

	If score = 0 then rc.timer := gTextLoad(getTimeString(game.time), rc.font)
	Else rc.timer := gTextLoad(intToStr(score), rc.font);

	gBeginRects(rc.timer);	// On affiche le timer
        	gSetCoordMode(G_CENTER);
       	   	gSetCoord(128, 32);
           	gSetColor(GUI_YELLOW);
          	gAdd();
	gEnd();

	gBeginRects(rc.b2Img);	// On affiche le bouton 2
		gSetCoordMode(G_CENTER);
		gSetCoord(128, 2 * ((G_SCR_H - 64) div 8) + 64);
		gSetColor(GUI_YELLOW);
		gAdd();
	gEnd();

	gBeginRects(rc.b3Img);
          	gSetCoordMode(G_CENTER);
          	gSetCoord(128, 5 * ((G_SCR_H - 64) div 8) + 64);
            	gSetColor(GUI_YELLOW);
          	gAdd();
	gEnd();
	gBeginRects(rc.b4Img);
          	gSetCoordMode(G_CENTER);
          	gSetCoord(128, 6 * ((G_SCR_H - 64) div 8) + 64);
            	gSetColor(GUI_YELLOW);
          	gAdd();
	gEnd();
	gBeginRects(rc.discoveredCases);	// On affiche les nombre de cases découvertes
          	gSetCoordMode(G_CENTER);
          	gSetCoord((G_SCR_W - 256) div 2 + 256, 32);
            	gSetColor(GUI_YELLOW);
          	gAdd();
	gEnd();

	For i := 0 to game.vertDim - 1 do	// On affiche le plateau
	Begin
		For j := 0 to game.horizDim - 1 do
		Begin
			gDrawRect(game.map[j][i].cX, game.map[j][i].cY, 32, 32, GUI_YELLOW);
				
			If game.map[j][i].cStatus = discovered then
			Begin
				Case game.map[j][i].cMines of
				1 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case1);
				2 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case2);
				3 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case3);
				4 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case4);
				5 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case5);
				6 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case6);
				7 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case7);
				8 : gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.case8);
				End;
			End
			Else If game.map[j][i].cStatus = flagged then
			Begin
				gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.hiddenCase);
				gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.flagImg);
			End
			Else if (game.map[j][i].cStatus = revealed) then		// Statut particulier pour les mines découvertes en fin de partie
				gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.mineImg)
			Else
				gDraw(game.map[j][i].cX, game.map[j][i].cY, rc.hiddenCase);

			If game.map[j][i].cIsSelected = true then
				gDrawRect(game.map[j][i].cX + 1, game.map[j][i].cY + 1, 32 - 2, 32 - 2, GUI_YELLOW);
			
		End;
	End;
End;

// ALORS, C'EST TRES SIMPLE ....
// Procédure : displayTerminalMap
// But : afficher une belle map en mode console
// Pour rappel : chaque case s'étend sur 3 lignes
Procedure displayTerminalMap(game : gameInformations);
Var i, j : integer;
Begin
	For i := 0 to game.vertDim - 1 do
	Begin
		For j := 0 to game.horizDim - 1 do	// Affichage de la ligne 1
		Begin
			If game.map[j][i].cIsSelected then
				TextColor(Red)
			Else If game.map[j][i].cStatus = discovered then
				TextColor(Green)
			Else If game.map[j][i].cStatus = flagged then
				TextColor(Blue)
			Else
				TextColor(White);
			write('+---+');
		End;
		writeLn('');
		For j := 0 to game.horizDim - 1 do	// Affichage de la ligne 2
		Begin
			If game.map[j][i].cIsSelected then
			Begin
				TextColor(Red);
				If game.map[j][i].cStatus = discovered then
				Begin
					Case game.map[j][i].cMines of 
						0 : write('|   |');
						1 : write('| 1 |');
						2 : write('| 2 |');
						3 : write('| 3 |');
						4 : write('| 4 |');
						5 : write('| 5 |');
						6 : write('| 6 |');
						7 : write('| 7 |');
						8 : write('| 8 |');
					End;
				End
				Else if game.map[j][i].cStatus = flagged then
					write('| F |')
				Else 
					write('|   |');
			End
			Else If game.map[j][i].cStatus = discovered then
			Begin
				TextColor(Green);
				Case game.map[j][i].cMines of 
						0 : write('|   |');
						1 : write('| 1 |');
						2 : write('| 2 |');
						3 : write('| 3 |');
						4 : write('| 4 |');
						5 : write('| 5 |');
						6 : write('| 6 |');
						7 : write('| 7 |');
						8 : write('| 8 |');
				End;
			End
			Else If game.map[j][i].cStatus = flagged then
			Begin
				TextColor(Blue);
				write('| F |');
			End
			Else If game.map[j][i].cStatus = revealed then
			Begin
				TextColor(Red);
				write('| M |');
			End
			Else
			Begin
				TextColor(White);
				write('|   |');
			End;
		End;
		writeLn('');
		For j := 0 to game.horizDim - 1 do	// Affichage de la ligne 3
		Begin
			If game.map[j][i].cIsSelected then
				TextColor(Red)
			Else If game.map[j][i].cStatus = discovered then
				TextColor(Green)
			Else If game.map[j][i].cStatus = flagged then
				TextColor(Blue)
			Else
				TextColor(White);
			write('+---+');
		End;
		WriteLn('');
	End;

	TextColor(white);
End;
