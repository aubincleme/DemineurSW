// Fonction : readHighScoresFile
// But : ouvrir un flux de lecture sur le fichier highscores.txt
Function readHighscoresFile() : highScoresInformations;
var	HSFile : highScoresInformations;
	fileCreation : TextFile;
	i : integer;
Begin
	If DirectoryExists('data') = false then
		CreateDir('data');

	If FileExists('data/highscores.txt') = false then	// On crée le fichier highscores
	Begin
		FileCreate('data/highscores.txt');
		assign(fileCreation, 'data/highscores.txt');
		rewrite(fileCreation);

		writeLn(fileCreation, '20');
		writeLn(fileCreation, 'dark sidious & dark vador');

		writeLn(fileCreation, '60');
		writeLn(fileCreation, 'grievious');

		writeLn(fileCreation, '150');
		writeLn(fileCreation, 'compte dooku');

		writeLn(fileCreation, '300');
		writeLn(fileCreation, 'dark maul');

		writeLn(fileCreation, '500');
		writeLn(fileCreation, 'jango & boba fett');

		writeLn(fileCreation, '800');
		writeLn(fileCreation, 'c3po');

		writeLn(fileCreation, '1000');
		writeLn(fileCreation, 'leia & padme');

		writeLn(fileCreation, '1800');
		writeLn(fileCreation, 'chewbacca');

		writeLn(fileCreation, '2500');
		writeLn(fileCreation, 'jabba');

		writeLn(fileCreation, '3600');
		writeLn(fileCreation, 'jarjarbinks');

		writeLn(fileCreation, '111111111111');
		writeLn(fileCreation, 'EOF');
		close(fileCreation);
	End;

	assign(HSFile.fileStream, 'data/highscores.txt');	// On ouvre le flux

	reset(HSFile.fileStream);

	For i := 1 to 11 do	// On initialise les tableaux de base
	Begin
		HSFile.names[i] := 'NULL';
		HSFile.scores[i] := 000000;
	End;

	i := 1;

	While (not Eof(HSFile.fileStream)) AND (HSFile.names[i] <> 'EOF') AND (i <= 11) do // On charge les tableaux avec les valeurs du fichier
	Begin
		readLn(HSFile.fileStream, HSFile.scores[i]);
		readLn(HSFile.fileStream, HSFile.names[i]);
		i := i + 1;
	End;

	readHighScoresFile := HSFile;
End;

// Procédure : appendHighScore
// But : ajouter un meilleur score au fichier data/highscores.txt
Procedure appendHighScore(HSFile : highScoresInformations; newScore : integer; newName : string; position : integer);
Var i : integer;
Begin
	For i := 10 downto 1 do		// On modifie les tableaux en mémoire contenant les meilleurs scores
	Begin
		If i = position then
		Begin
			HSFile.scores[i] := newScore;
			HSFile.names[i] := newName;
		End
		Else if i = 10 then
		Begin
			HSFile.scores[i] := 0;
			HSFile.names[i] := 'abc';
		End
		Else if (i > position) then
		Begin
			HSFile.scores[i + 1] := HSFile.scores[i];
			HSFile.names[i + 1] := HSFile.names[i];
		End;
	End;
	

	close(HSFile.fileStream);
	rewrite(HSFile.fileStream);
	For i := 1 to 10 do 	// On réécrit le fichier en entier
	Begin
		writeLn(HSFile.fileStream, HSFile.scores[i]);
		writeLn(HSFile.fileStream, HSFile.names[i]);
	End;
	
	writeLn(HSFile.fileStream, '11111111111');
	writeLn(HSFile.fileStream, 'EOF');

	close(HSFile.fileStream);
End;

// Procédure : resetHSFile
// But : écraser le fichier de meilleurs scores, pour pouvoir, par la suite, en regénérer un nouveau
Procedure resetHSFile();
Var HSFile : TextFile;
Begin

	If  DirectoryExists('data') AND FileExists('data/highscores.txt') then 
	Begin
		Assign(HSFile, 'data/highscores.txt');
		Erase(HSFile);
	End;
End;
