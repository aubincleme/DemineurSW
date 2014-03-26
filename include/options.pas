// Procédure : options
// But : afficher le menu des options
Procedure options(isGUI : boolean);
Var optionsMenu : array of string;
	endOptionsMenu : boolean;
	menuChoice : integer;
Begin
	SetLength(optionsMenu, 2);
	If isGUI then
	Begin
		optionsMenu[0] := 'reinitialiser les meilleurs scores';
		optionsMenu[1] := 'retour au menu principal';
	End
	Else
	Begin
		optionsMenu[0] := 'Réinitialiser les meilleurs scores';
		optionsMenu[1] := 'Retour au menu principal';
	End;

	endOptionsMenu := false;

	Repeat
		If isGUI then menuChoice := menuGUI(optionsMenu, 'options')
		Else menuChoice := menuTerminal(optionsMenu, 'Options');

		Case menuChoice of
			1 : resetHSFile();
			2 : endOptionsMenu := true;
		End;
	Until endOptionsMenu = true;
End;

