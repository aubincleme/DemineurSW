// Fonction : cleanMap
// Objectif : Initialiser la carte de jeu, toutes les cases sont considérées comme vides et cachées à l'issue de cette fonction
// Paramètres :
//		--> map : tableau à deux dimensions de smallCase, structure définie dans le main }
//		--> tHoriz et tVert : dimensions du plateau					 } Dans gameInformations
Procedure cleanMap(var game : gameInformations);
Var i, j: integer;
Begin
	For i := 0 to game.horizDim - 1 do
	Begin
		For j := 0 to game.vertDim - 1 do
		Begin
			game.map[i][j].cType := empty;
			game.map[i][j].cStatus := covered;
			game.map[i][j].cMines := 0;
			game.map[i][j].cIsGodCase := false;
			game.map[i][j].cIsNextToGC := false;
			game.map[i][j].cX :=  256 + (32 * i);
			game.map[i][j].cY := 64 + (32 * j);
		End;
	End;
End;

// Procédure : discoverMines
// But : découvrir toutes les mines du plateau en fin de partie
Procedure discoverMines(var game : gameInformations);
Var i, j : integer;
Begin
	For i := 0 to game.horizDim - 1 do
	Begin
		For j := 0 to game.vertDim - 1 do
			If game.map[i][j].cType = mined then game.map[i][j].cStatus := revealed;
	End;
End;
