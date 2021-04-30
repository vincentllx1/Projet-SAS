BLOC #3 : Les fonctions à connaitre pour manipuler les dates SAS

Introduction :
Le jeu de donnée que je vais utiliser fait état de la situation quotidiennes liée à la pandémie de covid depuis le 10 avril 2020. Dans un premier temps nous allons manipuler les dates de notre jeu de données, grâce notamment aux fonctions offertes par le logiciel SAS.

1-	Création d’un champ de date SAS à partir d’une variable caractères.
Comme nous l’avons vu durant le cours, lorsque l’on importe des données, les champs contenant des dates sont rarement compris comme tel par SAS. C’est pourquoi nous devons indiquer dans une première étape data, les traitements que supposent notre champ Date ici.
Nous appliquerons dans un premier temps deux approches vu pendant le cours : 

A.	Méthode par extraction
Dans le code ci-dessous, nous utilisons plusieurs fonctions pour extraire l’année, le mois et le jour de notre jeu de donné. La fonction substr nous permet de sélectionner certains caractères de notre variable Date, et la fonction input nous permet de convertir nos caractères en nombre. Ainsi, nous obtenons trois champs de type numérique. 
La fonction mdy indique à SAS comment créer une date sas à partir des variables crées précédemment.
Notons que le format est essentiel afin que l’on puisse lire notre date convenablement. Dans ce travail je garderai le format Date9. Comme format de référence. 

data date;
set covid_table;

annee=input(substr(Date,7,4),8.); *on extrait l'annÈe;
mois=input(substr(Date,1,2),8.); *on extrait le mois;
jour=input(substr(Date,4,2),8.); *on extrait le jour;

date_sas=mdy(mois,jour,annee); *on utilise nos prÈcÈdentes pour obtenir la date en format sas;

*de maniËre Èquivalente;
date_sas=mdy(input(substr(Date,1,2),8.),input(substr(Date,4,2),8.),input(substr(Date,7,4),8.));

format date_sas date9.;

run;

B.	Méthode par informat

L’informat de la variable Date peut également être utilisé dans le cas où la syntaxe de notre date correspond à un des formats de dates de SAS. Ici, nous remarquons que notre chaine de caractère qui forme la date s’apparente au format MMDDYY10.. À nouveau, grâce à la fonction input, SAS est en mesure d’interpréter convenablement notre chaine de caractère original. Encore une fois nous devons spécifier un format afin de pouvoir lire les dates convenablement.

data date1;
set covid_table;

date_sas=input(date,MMDDYY10.);

format date_sas date9.;
run;

2-	Création d’un champ à partir de date SAS, et d’une date SAS à partir d’un champ.

Bien que nous venions d’en utiliser une (mdy), il existe de nombreuses fonctions utiles à l’exploitation des dates dans SAS. Cette section fait état des fonctions qui nous permettront de créer des dates avec différentes syntaxe à partir d’autres variables.
Créer un champ avec la date actuelle peut se faire de plusieurs manières. En cours nous avons ainsi utilisé la fonction today() mais deux autre options nous permettent d’arriver au même résultat.

*today;
ajd1= date();
ajd2 = today(); *idem! simple prÈcision par rapport au cours;
ajd3 = "&sysdate"d;

Nous pouvons constater que les 3 fonctions retournent une date en tout point identique. Les deux premières ne peuvent pas contenir d’argument. La troisième est une macro, qui nous permets de récupérer la date du système.
La fonction quarter peut-être utilise lorsque l’on souhaite connaitre le trimestre auquel appartient une certaine variable (déjà au format date SAS). Par conséquent dans le code suivant, j’utilise cette fonction sur la variable date_sas crée à l’étape précédente. 

*quarter on peut obtenir le trimestre de la dates de notre fichier de donnÈes;
quarter=qtr(date_sas);

En exécutant cette fonction, la variable quarter que nous créons retourne le trimestre correspondant à la variable date_sas. Notons ici que l’output de cette fonction n’est plus un format date, mais un format numérique (1,2,3 ou 4 en fonction de la valeur de date_sas).
Lorsque l’on a affaire à des trimestres dans une base de données, nous pouvons générer une date sas grâce à la fonction yyq. Cette fonction prend en argument l’année et le trimestre de de la date que l’on souhaite générer. Ainsi dans le code qui suit nous sommes en mesures de retrouver la première date du trimestre correspondant de notre variable sas_date.

*on peut utilser la derniËre variable quarter pour gÈnÈrer la date du dÈbut du trimestre ;
datequarter = yyq(annee, quarter);

Les dates peuvent également s’écrire avec une syntaxe / normes différentes dans sas. Par exemple il est possible d’utiliser les jours julien pour représenter une date dans SAS. Deux types de jours juliens sont utilisable, juldate7 ou juldate. Ces deux fonctions retournent respectivement le jour julien en format numérique de longueur 7 ou 5. Un jour julien s’écrit avec l’année suivie du nombre écoulé de jours dans cette même année. On constate par conséquent que le 27 mars 2021 prendra la valeur 21086 2021086 (le 27 mars étant le 86e jour de l’année) après avoir exécuter le code suivant :

*juldate est un type de date un peu particulier : SAS nous donne la possibilitÈ de gener les jours julien de plusierus maniËre;
juld = juldate(date_sas);
juld7 = juldate7(date_sas);

Notons ici que ces fonctions retournent une valeur numérique. On perd par conséquent le format date SAS.
Cependant, la fonction datejul nous permets de retrouver le format de date SAS : En l’appliquant sur deux variables distinctes, et prenant en argument les variables aux longueurs différentes précédemment créés (juld et juld7), on observe que les résultats sont identiques. La fonction est en mesure de s’adapter aux deux types d’écritures des jours julien dans SAS. Finalement ces deux nouvelles variables seront équivalentes à au champs date_sas.

*on peut retomber sur nos pieds en utilisant ces derniËres variables pour gÈnÈrer une nouvelle date equivalent a datesas, on remarque que la fonction s'adapte selon la syntaxe de jour julien;
datejul1 = datejul(juld);
datejul2 = datejul(juld7);

Enfin, comme la fonction quarter, la fonction weekday nous permet de récupérer le jour de la semaine. Attention, ici 1 sera équivalent à dimanche et non lundi. 
*weekday;
weekd=weekday(date_sas);
De la même manière la fonction week indique le numéro de la semaine dans l’année. Il est par ailleurs possible de spécifier un « descriptor » qui permet de définir différement la semaine : le desripteur ‘u’ signifie que la semaine commence le dimanche alors que le descripteur ‘w’ considère que la semaine commence le lundi. Le descripteur ‘v’ spécifie le numéro de la semaine dont la valeur est représentée par un nombre entier compris entre 1 et 53. Le lundi est considéré comme le premier jour de la semaine et la semaine 1 de l'année est la semaine qui comprend à la fois le 4 janvier et le premier jeudi de l'année. Si le premier lundi de janvier est le deuxième, le troisième ou le quatrième, les jours précédents font partie de la dernière semaine de l'année précédente.
```SAS
*week;
week1=week(date_sas);
week2=week(date_sas,'u');
week3=week(date_sas,'v');
week4=week(date_sas,'w');
```

3-	Function d’intervalles de dates

Quand on parle de dates, il peut être utile de connaître un intervalle de temps particulier. Plusieurs fonctions pourront nous aider à cette fin.

La première fonction que nous allons voir nous permet de calculer le nombre d’année qui s’est écoulé entre deux dates. Le code ci-dessous illustre plusieurs syntaxes de la fonction possible. 
Par défaut la fonction yrdif considère qu’une année compte 365 jours et comprends des mois de 30 et 31 jours. Ici anneedif sera équivalent à anneedif4, puisque « act » considère la véritable (actuelle) longueur des mois et « 365 » considère une année de 365 jours. Il est par ailleurs possible de considérer qu’une année ne contient que des mois de 30 jours et 360 jours dans l’année (voir syntaxe de la fonction yrdif dans la variable anneedif2). À l’inverse, anneedif1 illustre une représentation exacte des dates. Dans notre sortie, on observe par conséquent de légères différences entre nos 5 variables (sauf entre anneedif et anneedif4)

anneedif=yrdif(date_sas, ajd1); *cette variable calcul le nombre d'annÈe entre la date du covid et ajd, pas trËs utile mais peut lÍtre pour calculer la relation entre un client et l'entreprise;
anneedif1=yrdif(date_sas, ajd1, "act/act");*act/act" utilise le nombre rÈel de jours et d'annÈes entre deux dates;
anneedif2=yrdif(date_sas, ajd1, "30/360");*30/360' spÈcifie un mois de 30 jours et une annÈe de 360 jours;
anneedif3=yrdif(date_sas, ajd1, "act/360");*act/360" utilise le nombre rÈel de jours entre deux dates pour calculer le nombre d'annÈes (calculÈ par le nombre de jours divisÈ par 360);
anneedif4=yrdif(date_sas, ajd1, "act/365");*act/365' utilise le nombre rÈel de jours entre les dates pour calculer le nombre d'annÈes (calculÈ par le nombre de jours divisÈ par 365);

Dans une même idée, la fonction datdif est tout aussi utile puisqu’elle nous permet de calculer la différence en jour entre deux dates. Notons que la différence ne prend pas en considération l’année : par conséquent le 1 avril 2020 et le 2 avril 2021 auront une différence d’un jour. L’argument optionnel pour yrdif est ici obligatoire : comme constaté précédemment l’argument « act/act » nous permet d’utiliser le nombre réel de jours et d'années entre deux dates alors que « 30/360 » indique un mois de 30 jours et une année de 360 jours.

jourdif1=datdif(date_sas, ajd1, "act/act"); *IMPORTANT ici on est obligÈ de prÈciser la mÈthode utilisÈ par la fonction, contrairement ‡ la fonction yrdif + on calcul le nombre de jour sans prendre en compte les annÈes !;
jourdif2=datdif(date_sas, ajd1, "30/360"); *SAS ne prend en compte que deux mÈthode pour la fonction datdif contre quatre pour yrdif;
jourdif3=datdif(date_sas, ajd1, "act/360");
jourdif4=datdif(date_sas, ajd1, "30/360");

Sommes toutes, ces fonctions ne sont pas très flexibles. La fonction intck est d’autant plus intéressante qu’elle nous permet de spécifier l’intervalle que l’on souhaite calculer. On doit spécifier le type d’intervalle en premier argument avant de préciser la date de départ et la date de fin de l’intervalle de temps. Ici on fait la comparaison avec les résulats obtenus précédemment. On observe que, bien que flexible, cette fonction nous offre moins de précisions dans la mesure où nous ne sommes pas en mesure de contrôler la méthode de calcul, et qu’elle incrémente automatiquement les résultats pour l’année. Ainsi, dans notre contexte, la variable anneedif5 prendra la valeur 0 sur une partie du jeu de donnée (puisque moins de 1 ans c’est écoulé). Jourdif3 semble rapporter exactement les mêmes résultats. Notons ici que plusieurs manières d’incrémenter notre date SAS sont utilisable : 'weekday', 'week', 'month', 'qtr', and 'year' par exemple. 

anneedif5=intck("year", date_sas, ajd1);*on fixe un intervalle de 1 an a calculer, on constate qu'il n'y a pas d'arrondit;
jourdif3=intck("day", date_sas, ajd1);*'day', 'weekday', 'week', 'month', 'qtr', and 'year' sont des exemples d'intervalles valides;

Pourquoi est-ce le cas ? Cela est dû au fait que la fonction intck( ) compte les intervalles à partir de débuts d'intervalles fixes, et non en multiples d'une unité d'intervalle à partir de la valeur de la date de début. Les intervalles partiels ne sont pas comptés. Par exemple, les intervalles de "semaine" sont comptés par dimanches plutôt que par multiples de sept jours de la valeur de la date de début. Les intervalles "mois" sont comptés par le premier jour de chaque mois, et les intervalles "année" sont comptés à partir du 1er janvier, et non en multiples de 365 jours à partir de la date de début.

Finalement, la fonction intnx nous permets de projeter une nouvelle date avec un certain délai dans le temps. Ici encore, plusieurs types d’incrément sont possible. La particularité de cette fonction c’est qu’elle nous renvoie automatiquement la première date des deux prochains mois, dans le cas de notre syntaxe ci-dessous : Nous observons, dans la variable moisdif que nous obtenons le premier jour du deuxième mois suivant la date de l’observation contenue dans la variable date_sas. Les arguments optionnels de la fonction nous permettent de changer cette valeur, en précisant à sas de nous retourner la valeur au début (idem que par défaut) avec « beginning » : la valeur au milieu du deuxième mois avec « middle », la valeur à la fin du deuxième mois avec « middle », ou bien la même valeur de date dans deux mois.

moisdif_paire1=intnx("month",date_sas, 2); * on observe que sas nous retourne automatiquement la premiËre date du deuxiËme mois aprËs le mois de sas_date;
moisdif_paire2=intnx("month",date_sas, 2, "beginning"); * idem !;
moisdif_paire3=intnx("month",date_sas, 2, "middle");
moisdif_paire4=intnx("month",date_sas, 2, "end");
moisdif_paire5=intnx("month",date_sas, 2, "sameday");



# Bloc#4: Le langage macro – pour aller plus loin

## Introduction :

Dans cette section, je vais m’attarder sur les macro-sas. Nous verrons comment cette procédure s’avère particulièrement utile pour générer des rapports. Ici nous verrons comment les macros peuvent nous renseigner sur la situation du covid au québec.

En guise de rappel, voici un bref descriptif des variables (nous retrouverons les régions administratives RSS déjà évoqué dans notre précédent devoir sur R) :
- ACT_Hsi_RSS01 : Nombre d'hospitalisations actives (hors soins intensifs) dans la région 01 (Bas-Saint-Laurent)
- ACT_Hsi_RSS99 : Nombre d'hospitalisations actives (hors soins intensifs) dans l’ensemble du Québec
- ACT_Si_RSS01 : Nombre d'hospitalisations actives (soins intensifs) dans la région 01
- ACT_Hsi_RSS99 : Nombre d'hospitalisations actives (soins intensifs) dans l’ensemble du Québec
- ACT_Total_RSS01 : Nombre d'hospitalisations actives dans la région 01
- ACT_Total_RSS99 : Nombre d'hospitalisations actives dans l’ensemble du Québec

## 1)	Stocker de l’information
Nous avons précédemment vu que nous pouvions stocker de l’information dans des variables d’une table SAS. Les variables macros sont une alternative aux tables SAS : Elles nous permettent de stocker de l’information de plusieurs manières.
L’énoncé %let nous permet de stocker une chaine de caractères dans une variable nommé précédemment. Pour faire référence à cette variable, et l’afficher dans notre journal nous devons utiliser l’énoncé 
%put.
```SAS
%let annee=2020;
%put le contenu de annee est &annee.;
```
On remarque que notre chaine de caractères initié après l’ennoncé %put est bien imprimé.

Pour réaliser des additions sur cette variables macro, nous devons par conséquent la traiter différemment, grâce à la fonction %eval qui nous permet d’évaluer des expressions arithmétiques et logiques sur notre variable macro.

```SAS
%let anneesuivante=%eval(&annee.+1);
%put le contenu de anneesuivante est &anneesuivante.;
```

D’autres fonction spécifique aux macros sont disponibles. Ainsi on peut également décider d’utiliser 
```SAS
%substr pour extraire une chaine de caractère de notre macro.

%let chainedecar=ceci est une chaine de caracteres;
%put le troisieme mot de chainedecar est %substr(&chainedecar.,14,6);
```
 

Une autre manière de stocker de l’information en provenance de table de données peut se faire à l’intérieur d’une étape data. Ici notre objectif est de créer une macro qui nous permettra de stocker le nombre total de personnes hospitalisés à cause du covid au québec. Nous allons également voir que ces variables peuvent être « globales » ou « locales ».
```SAS
%macro Total;
proc summary data = date3;
		var ACT_Total_RSS99;
		output out = somme (drop = _:) sum=;
run;

data _null_;
	set somme;
	call symputx("nb_covid_total1", put(ACT_Total_RSS99, 8.), "G");* Global;
	call symputx("nb_covid_total2", put(ACT_Total_RSS99, 8.), "L");* Local;
	call symput("nb_covid_total3", put(ACT_Total_RSS99, 8.));
run;
%put nombre total de personnes hospitalisees au quebec = &nb_covid_total3.;
%mend Total;
```
Cette macro contient plusieurs étapes :
D’abord, on agrège l’ensemble des valeurs de la variables ACT_Total_RSS99 en effectuant la somme des observations. La table qui résulte de cette agrégation se nomme somme


Ensuite, dans une étape data _null_ (_null_ indique qu’aucune table ne sera produite en sortie) qui reprends notre table somme nous allons récupérer cette information pour la stocker dans 3 variables macro (« nb_covid_total1 », « nb_covid_total2 », « nb_covid_total3 »). Pour ce faire, nous allons utiliser l’énoncé CALL SYMPUTX qui permet de créer une ou plusieurs variables macro à l’intérieur d’une étape DATA. Cette fonction diffère de CALL SYMPUT que nous avons vu en classe puisque nous pouvons indiquer en dernier argument si l’on souhaite que soit Golabal « G » ou Locale « L ». Notons la fonction put() ici est importante pour retourner la variable numérique en caractères.


Enfin, on inclut un énoncé %put à la fin de notre macro qui restituera la valeur capturée par nb_covid_total3.

Pour executer notre nouvelle macro %Total, il suffit de l’appeler :
```SAS
%Total
```

On observe que notre énoncé %put nous a bel et bien donné le nombre total d’hospitalisations au Québec grâce à la variable « nb_covid_total3 ».

Mais essayons maintenant de consulter le contenu de nos trois variables à l’extérieur de notre macro 
```SAS
%put nombre total de personnes hospitalisees au quebec1 = &nb_covid_total1.;
%put nombre total de personnes hospitalisees au quebec2 = &nb_covid_total2.;
%put nombre total de personnes hospitalisees au quebec3 = &nb_covid_total3.;
```
 

On constate que SAS nous retourne le nombre total de personnes hospitalisées pour les variables macros &nb_covid_total1. Et &nb_covid_total3.. Nous avions indiqué &nb_covid_total1 comme une variable globale avec « G » : Nous constatons qu’elle peut être appellé même en dehors de la macros Total. On constate par conséquent que la fonction call symput crée des variables globales automatiquement ! En revanche lorsque l’on a précisé que la variable &nb_covid_total2. Devait être local, on remarque que SAS ne la trouve pas : il retourne un . à la place.

 
## 2)	Créations de macros avec arguments ;

Nous sommes maintenant en mesure de créer des macros plus complexes, on peut permettre à l'utilisateur d'insérer la variable qu'il préférer consulter par exemple. Nous souhaitons par ailleurs que, par défaut, la macro donnera la somme des hospitalisations au québec. Nous nommons cette macro Total_var.
```SAS
%macro Total_var(var=ACT_Total_RSS99);
proc summary data = date3;
	var &var.;
	output out = somme (drop = _:) sum=;
run;

data _null_;
		set somme;
		call symputx("nb_covid_total_var1", put(&var., 8.), "G");* Global;
run;

%put nombre total de personnes hospitalisees sur &var. = &nb_covid_total_var1.;
%mend Total_var;
```
Nous pouvons donc executer notre macro sans spécifier de variable : nous obtiendrons les résultats pour ACT_Total_RSS99 :
```SAS
%Total_var();
```
 

Autrement, en spécifiant une autre variable on obtient la somme de cette dernière :
```SAS
%Total_var(var=ACT_Si_RSS99);
```

 
Notre macro est encore très rigide, pour donner plus de flexibilité à l’utilisateurs, on aimerait connaître avec plus en détails certaines périodes. Commençons par permettre à l'utilisateur de sélectionner une date précise. Notre macro date prendra en argument Date= en plus de var=. Notons que cette étape nécessite une étape data préalable que l’on appellera test et qui nous permettra de sélectionner l’observation correspondant à la date entrée en argument à la fonction.
```SAS
%macro date(date=, var=ACT_Total_RSS99);

data test;
set date3;
if date_sas = "&date."d;
run;

proc summary data = test;
	var &var.;
	output out = somme (drop = _:) sum=;
run;
data _null_;
		set somme;
		call symputx("nb_covid_jour", put(&var., 8.), "G");* Global;
run;
%put nombre total de personnes touchÈes par le covid le &date. = &nb_covid_jour.;
%mend date;
```
En exécutant cette macro, nous obtenons le résultat du 18 février 2021 pour toutes les hospitalisations au Québec. Ainsi : 
```SAS
%date(date=18FEB2021);
````

 
Notre utilisateur nous mentionne que maintenant, la variable est trop restrictive : Il aimerait pouvoir spécifier sa plage de date, et connaitre l’augmentation moyenne des cas (seulement s’il spécifie aug=1). Finalement il aimerait également avoir une représentation visuelle de l’évolution des cas dans le temps par rapport à la fonction de référence « ACT_Total_RSS99 ».
Nous devrons donc spécifier notre première étape data pour n’inclure que les données dans l’interval [début :fin] : Nous faisons appel à la fonction lag() qui nous permet de calculer la valeur précédentes de l’observation. Attention, l’ordre de notre table est par conséquent très important ici. Nous spécifions l’ordre ascendant sur la variable date_sas grâce à la procédure SORT.
```SAS
data test;
set test;
if "&debut."d <= date_sas <= "&fin."d;
augm=&var.-lag(&var.);
run;
```
Nous devons également faire évoluer notre procédure SUMMARY en incluant un énoncé conditionnel macro. Ces énoncés sont particulièrement pratiques puisqu’ils nous permettent de modeler nos procédures selon certaine condition, ce qui est impossible en dehors des macros. Ici nous souhaitons retourner une table somme dans les deux cas mais qui dans le cas ou aug=1 elle calculera la moyenne de l’augmentation du nombre d’hospitalisation sur la durée définit par l’utilisateur.
```SAS
proc summary data = test;
	%if &aug. = 0 %then %do; 
	var &var.;
	output out = somme (drop = _:) sum=&var. %end;
	%else %if &aug. = 1 %then %do;
	var augm;
	output out = somme (drop = _:) mean=augm %end;;
run;
```
Cet énoncé conditionnel doit être répété lors de la prochaine étape pour indiquer quelle valeur prendre en fonction de l’indication de l’utilisateur. Notons ici, que chaque énoncé conditionnel possède ces propres points virgules. C’est pourquoi chacun de nos derniers énoncés prend deux points virgules : un pour l’énoncé conditionnel, un autre pour clore l’énoncé de la procédure.
```SAS
data _null_;
		set somme;
		%if &aug. = 0 %then %do; 
		call symputx("nb_covid_jour", put(&var., 8.), "G"); %end;* Global;
		%if &aug. = 1 %then %do;
		call symputx("nb_covid_jour", put(augm, 8.), "G"); %end;;* Global;
run;
```
Nous sommes en mesure d’imprimer le résultats obtenus à travers les étapes précédentes :
```SAS
%if &aug. = 0 %then %do; 
%put nombre total de personnes touchÈes par le covid entre le &debut. et le &fin. pour la variable &var. = &nb_covid_jour.;%end;
%if &aug. = 1 %then %do;
%put nombre moyen de personnes touchÈes par le covid entre le &debut. et le &fin. pour la variable &var. = &nb_covid_jour.;%end;
```
Finalement, nous pouvons produire un graphe grâce à la procédure SGPLOT : Ici encore, en fonction de la valeur entrée par l’utilisateur sous var=, nous devons ajuster notre graphique. En effet s’il souhaite consulter que l’évolution du courbe total par défaut, nous devons présenter qu’une seule courbe autrement il pourra distinguer la courbe de sa variable en fonction du total d’hospitalisation au québec.
```SAS
PROC SGPLOT DATA = test;
%if &var.= ACT_Total_RSS99 %then %do;
SERIES Y = &var. X = date_sas; %end;
%else %if &var. ne ACT_Total_RSS99 %then %do;
SERIES Y = ACT_Total_RSS99 X = date_sas;
SERIES Y = &var. X = date_sas; %end;
RUN;
```
```SAS
%intervalle(debut=10FEB2021,fin=19MAR2021,var=ACT_Si_RSS99)
```
```SAS
%intervalle(debut=10FEB2021,fin=19MAR2021,var=ACT_Total_RSS06,aug=1)
```

Vous retrouverez le code complet de la macro sci-dessous :
```SAS
%macro intervalle(debut=,fin=,var=ACT_Total_RSS99,aug=0);

proc sort data=date3 out=test; by date_sas; run;

data test;
set test;
if "&debut."d <= date_sas <= "&fin."d;
augm=&var.-lag(&var.);
run;

proc summary data = test;
	%if &aug. = 0 %then %do; 
	var &var.;
	output out = somme (drop = _:) sum=&var. %end;
	%else %if &aug. = 1 %then %do;
	var augm;
	output out = somme (drop = _:) mean=augm %end;;
run;

data _null_;
		set somme;
		%if &aug. = 0 %then %do; 
		call symputx("somme", put(&var., 8.), "G"); %end;* Global;
		%if &aug. = 1 %then %do;
		call symputx("moyenne", put(augm, 8.), "G"); %end;;* Global;
run;

%if &aug. = 0 %then %do; 
%put nombre total de personnes hospitalise par le covid entre le &debut. et le &fin. pour la variable &var. = &somme.;%end;
%if &aug. = 1 %then %do;
%put nombre moyen de personnes hospitalise par le covid entre le &debut. et le &fin. pour la variable &var. = &moyenne.;%end;

PROC SGPLOT DATA = test;
%if &var.= ACT_Total_RSS99 %then %do;
SERIES Y = &var. X = date_sas; %end;
%else %if &var. ne ACT_Total_RSS99 %then %do;
SERIES Y = ACT_Total_RSS99 X = date_sas;
SERIES Y = &var. X = date_sas; %end;
RUN;

%mend intervalle; 
```

Finalement, notre utilisateur aimera pouvoir distinguer différents intervalles pour visionner la fréquentation des hôpitaux. C’est l’occasion rêvé d’utiliser nos fonctions d’intervalles de temps utilisé lors du bloc 3 ! Nous devons par conséquent modifier notre macro précédente comme suit.
Nous devrons commencer par modifier notre première étape data pour ajouter un argument qui calcul la différence entre deux dates en fonction du type d’intervalle définit par l’utilisateur. A cette fin, nous utiliserons la fonction intck. La variable int sera par conséquent en mesure de caluler l’intervalle spécifique entre les deux dates ! Notons que nous devons multiplier par -1 pour obtenir la valeur absolue de la différence entre les deux date (puisque début est équivalent ou inférieur à date sas). 
```SAS
proc sort data=date3 out=test; by date_sas; run;

data test;
set test (where =("&debut."d <= date_sas <= "&fin."d));
augm=&var.-lag(&var.);
int=intck("&int.",date_sas,"&debut"d)*-1;
run;
```
Les étapes suivantes sont identiques à l’exeption de la création de notre graphique qui doit prendre en compte cette nouvelle variable int. On remarque en effet que l’on a remplacé date_sas par int, qui nous permettra de placer cette nouvelle variable sur l’axe des abscisses.
```SAS
PROC SGPLOT DATA = test;
	%if &var.= ACT_Total_RSS99 %then %do;
		SERIES Y = &var. X = int; %end;
	%else %if &var. ne ACT_Total_RSS99 %then %do;
		SERIES Y = ACT_Total_RSS99 X = int;
		SERIES Y = &var. X = int; %end;
RUN;
```
Finalement, lorsque l’on exécute notre macro avec un interval par semaine, nous obtenons les sorties suivantes.
```SAS
%intervalle2(debut=10NOV2020,fin=25JAN2021,var=ACT_Total_RSS99,int=weeks)
``` 
```SAS
%intervalle2(debut=10NOV2020,fin=25JAN2021,var=ACT_Total_RSS06,aug=1,int=weeks)
```
 
Vous retrouverez le code complet de la macro ci-dessous :
```SAS
%macro intervalle2(debut=,fin=,var=ACT_Total_RSS99,aug=0, int=day);

proc sort data=date3 out=test; by date_sas; run;

data test;
set test (where =("&debut."d <= date_sas <= "&fin."d));
augm=&var.-lag(&var.);
int=intck("&int.",date_sas,"&debut"d)*-1;
run;

proc summary data = test;
	%if &aug. = 0 %then %do; 
	var &var.;
	output out = somme (drop = _:) sum=&var. %end;
	%else %if &aug. = 1 %then %do;
	var augm;
	output out = somme (drop = _:) mean=augm %end;;
run;

data _null_;
		set somme;
		%if &aug. = 0 %then %do; 
		call symputx("nb_covid_jour", put(&var., 8.), "G"); %end;* Global;
		%if &aug. = 1 %then %do;
		call symputx("nb_covid_jour", put(augm, 8.), "G"); %end;;* Global;
run;

%if &aug. = 0 %then %do; 
%put nombre total de personnes hospitalise par le covid entre le &debut. et le &fin. pour la variable &var. = &nb_covid_jour.;%end;
%if &aug. = 1 %then %do;
%put nombre moyen de personnes hospitalise par le covid entre le &debut. et le &fin. pour la variable &var. = &nb_covid_jour.;%end;

PROC SGPLOT DATA = test;
	%if &var.= ACT_Total_RSS99 %then %do;
		SERIES Y = &var. X = int; %end;
	%else %if &var. ne ACT_Total_RSS99 %then %do;
		SERIES Y = ACT_Total_RSS99 X = int;
		SERIES Y = &var. X = int; %end;
RUN;

%mend intervalle2;
```
```SAS
%intervalle2(debut=10NOV2020,fin=25MAR2021,var=ACT_Si_RSS01,int=weeks)
```