// Fichier : time.pas : Gestion du temps

// Fonction : LO (copiée de la doc. Pascal), permet de passer d'un word à un string
Function L0(w:word) : string;
Var s : string;
Begin
  	Str(w,s);
	If w<10 then
		L0:='0'+s
	Else
		L0:=s;
End;

// Fonction : getTimeString
// But : Obtenir une variable de type String contenant le temps écoulé depuis le début de la partie sous la forme  : HH:MM:SS
// Utilisée pour l'affichage graphique uniquement
Function getTimeString(var time : timeInformations) : string;
Var timeAtStartSum, actualTimeSum : integer;
	hours, mins, secs, mSecs : word;
Begin
	If (time.secsAtStart = 0) AND (time.minsAtStart = 0) AND (time.hoursAtStart = 0) then	// Si le compteur n'a pas démarré
		getTimeString := '00:00'
	Else
	Begin
		getTime(hours, mins, secs, mSecs);
		timeAtStartSum := time.secsAtStart + (60 * time.minsAtStart) + (3600 * time.hoursAtStart);
		actualTimeSum := secs + (60 * mins) + (3600 * hours);
		actualTimeSum := actualTimeSum - timeAtStartSum;
		secs := actualTimeSum mod 60;									// Calcul du temps
		mins := (actualTimeSum mod 3600) div 60;
		hours := actualTimeSum div 3600;
		time.secs := secs;
		time.mins := mins;
		time.hours := hours;
		getTimeString := L0(mins) + ':' + L0(secs);
	End;
End;

// Procédure : getFinalScore
// But : générer le scores final obtenu par le joueur en fonction de son temps de jeu
Procedure getFinalScore(var time : timeInformations);
Var timeAtStartSum, actualTimeSum : integer;
	hours, mins, secs, mSecs : word;
Begin
	getTime(hours, mins, secs, mSecs);
	timeAtStartSum := time.secsAtStart + (60 * time.minsAtStart) + (3600 * time.hoursAtStart);
	actualTimeSum := secs + (60 * mins) + (3600 * hours);
	actualTimeSum := actualTimeSum - timeAtStartSum;
	time.secs := actualTimeSum mod 60;
	time.mins := (actualTimeSum mod 3600) div 60;
	time.hours := actualTimeSum div 3600;
End;
