// Procédure : newGame
// Objectif : superviser la création d'un nouveau plateau de jeu en fonction des choix de l'utilisateur
// Cette fonction est la même en console ou en GUI
Procedure newGame(isGUI : boolean);
Var	endNewGame, settingsOk : boolean; // endNewGame est présent pour donner au joueur la possibilité de retourner au menu principal
	menuChoice : integer;
	persoParams : personnalGameParameters; // Variables uniquement utilisées pour les paramètres de jeu personnalisés
	menuOptions : array of string;
Begin

	SetLength(menuOptions, 5);
	If isGUI then
	Begin
		menuOptions[0] := 'padawan';
		menuOptions[1] := 'jedi';
		menuOptions[2] := 'yoda';
		menuOptions[3] := 'personnaliser la grille';
		menuOptions[4] := 'retour au menu principal';
	End
	Else
	Begin
		menuOptions[0] := 'Padawan';
		menuOptions[1] := 'Jedi';
		menuOptions[2] := 'Yoda';
		menuOptions[3] := 'Personnaliser la grille';
		menuOptions[4] := 'Retour au menu principal';
	End;

	endNewGame := false;
	
	Repeat
		If isGUI then menuChoice := menuGUI(menuOptions, 'nouvelle partie')
		Else menuChoice := menuTerminal(menuOptions, 'Nouvelle partie');

		Case menuChoice of	// En fonction des valeures renvoyées par les fonctions de menus
			1 : minesweeper(10, 8, 8, isGUI);
			2 : minesweeper(40, 16, 16, isGUI);
			3 : minesweeper(99, 30, 16, isGUI);
			4 : Begin 	// On va récupérer les paramètres de jeu personnalisés de l'utilisateur
				If isGUI then
					getPersonnalizedOptions(persoParams)	// Cf. newGameFunctions.pas
				Else
				Begin
					settingsOk := false;
					Repeat
						write('Entrez la longueur du plateau : ');
						readLn(persoParams.x);
						write('Entrez la largeur du plateau : ');
						readLn(persoParams.y);
						write('Entrez le nombre de mines (1 - 99) : ');
						readLn(persoParams.minesNbr);

						If (persoParams.minesNbr > 2) 
						AND (persoParams.minesNbr <= 99)
						AND (persoParams.x > 5) 
						AND (persoParams.y > 5) 
						AND (persoParams.minesNbr + 10 <= persoParams.x * persoParams.y) then
							settingsOk := true
						Else
							writeLn('ERREUR : Les paramètres sont incorrects !');
						
					Until settingsOk = true;
					minesweeper(persoParams.minesNbr, persoParams.x, persoParams.y, false);	// On lance minesweeper
				End;
			End;
			5 : endNewGame := true;
		End;
	Until endNewGame = true;
End;
