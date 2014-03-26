Program Demineur;

Uses gLib2D, SDL, SDL_TTF, SDL_Addon, crt, sysutils, Dos, classes;

{$I 'include/types.pas'}	// Inclusion des types, ils sont assez nombreux, donc on a préféré les mettre à part ...
{$I 'include/const.pas'}

{$I 'include/time.pas'}			// Fichier time.pas : gère le compteur du jeu
{$I 'include/fileOperations.pas'}	// Fichier fileOperations.pas : gère la sauvegarde des meilleurs scores
{$I 'include/mapFunctions.pas'}		// Fichier mapFunctions.pas : gère les modifications générales du plateau
{$I 'include/display.pas'}		// Fichier display.pas : gère l'affichage des plateaux, ainsi que des boutons de la GUI
{$I 'include/playerChoice.pas'}		// Fichier playerChoice.pas : gère la saisie en jeu de l'utilisateur
{$I 'include/menus.pas'}		// Fichier menus.pas : gère l'affichage de différents menus (Console et GUI)
{$I 'include/highscores.pas'}		// Fichier highscores.pas : gère l'affichage des meilleurs scores
{$I 'include/endOfGame.pas'}		// Fichier endOfGame.pas : gère les fonctions de fin de jeu (meilleurs scores, etc ...)
{$I 'include/minesweeper.pas'}		// Fichier minesweeper.pas : gère le déroulement du jeu
{$I 'include/newGameFunctions.pas'}	// Fichier newGameFunctions.pas : gère la saisie des paramètres de plateau personnalisés
{$I 'include/newGame.pas'}		// Fichier newGame.pas : gère le menu "Nouvelle Partie"
{$I 'include/options.pas'}		// Fichier options.pas : gère le menu "Options"

VAR	mainMenuItems : array of string;
	endProg, isGUI : boolean;
	menuChoice : integer;
BEGIN
	Randomize;	// Pour avoir du bon random ^^
	If (ParamStr(1) = '-c') OR (ParamStr(1) = '--command') then	// Démarrage en mode CONSOLE
	Begin
		isGUI := false;
		setLength(mainMenuItems, 4);				// On prépare le menu principal version CONSOLE
		mainMenuItems[0] := 'Nouvelle partie';			// En mode graphique,
		mainMenuItems[1] := 'Meilleurs scores';			// la police d'écriture que nous utilisons ne nous permet pas d'utiliser
		mainMenuItems[2] := 'Options';				// des majuscules (ça devient très moche).
		mainMenuItems[3] := 'Quitter';
	End
	Else if (ParamCount = 0) OR (((ParamStr(1) = '-gui') OR (ParamStr(1) = '--graphic'))) then // démarrage en mode GUI
	Begin
		isGUI := true;
		gInit('Demineur - Star Wars Edition', 800, 600);	// On intialise la fenètre
		setLength(mainMenuItems, 4);				// On prépare le menu principal version GRAPHIQUE
		mainMenuItems[0] := 'nouvelle partie';
		mainMenuItems[1] := 'meilleurs scores';
		mainMenuItems[2] := 'options';
		mainMenuItems[3] := 'quitter';
	End
	Else
	Begin
		writeLn('Erreur critique : le paramètre entré est incorrect, veuillez réessayer.');
		halt;
	End;

	

	Repeat		// Petite boucle
		endProg := false;
		If isGUI then menuChoice := menuGUI(mainMenuItems, 'menu principal') 	// On utilise deux fonctions de menu différentes
		Else menuChoice := menuTerminal(mainMenuItems, 'Menu principal');

		Case menuChoice of
		1 : newGame(isGUI);
		2 : displayHighScores(isGUI);
		3 : options(isGUI);
		4 : endProg := true;
		End;
	Until endProg = true;
END.

(* EOF *)
