%let path=\\Mac\Home\Desktop\02-Logiciels Statistiques\Projet\SAS\Covid\COVID19_Qc_HistoHospit.csv;


filename covid "&path.";

data covid_table;
	infile covid dsd missover dlm="," firstobs = 2;
	input
Date:$15.
ACT_Hsi_RSS01:8.
ACT_Hsi_RSS02:8.
ACT_Hsi_RSS03:8.
ACT_Hsi_RSS04:8.
ACT_Hsi_RSS05:8.
ACT_Hsi_RSS06:8.
ACT_Hsi_RSS07:8.
ACT_Hsi_RSS08:8.
ACT_Hsi_RSS09:8.
ACT_Hsi_RSS10:8.
ACT_Hsi_RSS11:8.
ACT_Hsi_RSS12:8.
ACT_Hsi_RSS13:8.
ACT_Hsi_RSS14:8.
ACT_Hsi_RSS15:8.
ACT_Hsi_RSS16:8.
ACT_Hsi_RSS17:8.
ACT_Hsi_RSS18:8.
ACT_Hsi_RSS99:8.
ACT_Si_RSS01:8.
ACT_Si_RSS02:8.
ACT_Si_RSS03:8.
ACT_Si_RSS04:8.
ACT_Si_RSS05:8.
ACT_Si_RSS06:8.
ACT_Si_RSS07:8.
ACT_Si_RSS08:8.
ACT_Si_RSS09:8.
ACT_Si_RSS10:8.
ACT_Si_RSS11:8.
ACT_Si_RSS12:8.
ACT_Si_RSS13:8.
ACT_Si_RSS14:8.
ACT_Si_RSS15:8.
ACT_Si_RSS16:8.
ACT_Si_RSS17:8.
ACT_Si_RSS18:8.
ACT_Si_RSS99:8.
ACT_Total_RSS01:8.
ACT_Total_RSS02:8.
ACT_Total_RSS03:8.
ACT_Total_RSS04:8.
ACT_Total_RSS05:8.
ACT_Total_RSS06:8.
ACT_Total_RSS07:8.
ACT_Total_RSS08:8.
ACT_Total_RSS09:8.
ACT_Total_RSS10:8.
ACT_Total_RSS11:8.
ACT_Total_RSS12:8.
ACT_Total_RSS13:8.
ACT_Total_RSS14:8.
ACT_Total_RSS15:8.
ACT_Total_RSS16:8.
ACT_Total_RSS17:8.
ACT_Total_RSS18:8.
ACT_Total_RSS99:8.;
run;

%let path2=\\Mac\Home\Desktop\02-Logiciels Statistiques\Projet\SAS\Covid;


libname covid "&path2.";


data covid.covid_table;
set covid_table;
run;

*Convertir notre format char en date^;

*approche 1;
data date;
set covid_table;

annee=input(substr(Date,7,4),8.); *on extrait l'année;
mois=input(substr(Date,1,2),8.); *on extrait le mois;
jour=input(substr(Date,4,2),8.); *on extrait le jour;

date_sas=mdy(mois,jour,annee); *on utilise nos précédentes pour obtenir la date en format sas;

*de manière équivalente;
date_sas=mdy(input(substr(Date,1,2),8.),input(substr(Date,4,2),8.),input(substr(Date,7,4),8.));

format date_sas date9.;

run;

*approche 2;

data date1;
set covid_table;

date_sas=input(date,MMDDYY10.);

format date_sas date9.;
run;

proc print data=date1 (obs=5);
var date_sas;
run;

*fonctions dates;

*nous venons d'en utitliser quelques unes mais il en existe un certain nombre, aux utilités différentes;

*créer des nouvelles dates;
data date2;
set date1;

*today;
ajd1= date();
ajd2 = today(); *idem! simple précision par rapport au cours;
ajd3 = "&sysdate"d;

*vu précedemment;
annee=input(substr(Date,7,4),8.);
mois=input(substr(Date,1,2),8.);
jour=input(substr(Date,4,2),8.);
date_sas=mdy(mois,jour,annee);

*quarter on peut obtenir le trimestre de la dates de notre fichier de données;
quarter=qtr(date_sas);

*on peut utilser la dernière variable quarter pour générer la date du début du trimestre ;
datequarter = yyq(annee, quarter);

*juldate est un type de date un peu particulier: SAS nous donne la possibilité de gener les jours julien de plusierus manière;
juld = juldate(date_sas);
juld7 = juldate7(date_sas);

*on peut retomber sur nos pieds en utilisant ces dernières variables pour générer une nouvelle date equivalent a datesas, on remarque que la fonction s'adapte selon la syntaxe de jour julien;
datejul1 = datejul(juld);
datejul2 = datejul(juld7);

*weekday;
weekd=weekday(date_sas);
*week;
week1=week(date_sas);
week2=week(date_sas,'u');
week3=week(date_sas,'v');
week4=week(date_sas,'w');

format ajd1 ajd2 ajd3 datequarter datejul1 datejul2 date9.;
run;

proc print data=date2 (obs=10);
var date_SAS ajd1 ajd2 ajd3 quarter datequarter juld juld7 datejul1 datejul2 weekd week1-week4;
run;


*fonctions d'intervalles de dates;

*maintenant que l'on a creer quelques variables contenant de nouvelles dates, on peut essayer de les exploiter;


data date3;
set date2;

anneedif=yrdif(date_sas, ajd1); *cette variable calcul le nombre d'année entre la date du covid et ajd, pas très utile mais peut lêtre pour calculer la relation entre un client et l'entreprise;
anneedif1=yrdif(date_sas, ajd1, "act/act");*act/act" utilise le nombre réel de jours et d'années entre deux dates;
anneedif2=yrdif(date_sas, ajd1, "30/360");*30/360' spécifie un mois de 30 jours et une année de 360 jours;
anneedif3=yrdif(date_sas, ajd1, "act/360");*act/360" utilise le nombre réel de jours entre deux dates pour calculer le nombre d'années (calculé par le nombre de jours divisé par 360);
anneedif4=yrdif(date_sas, ajd1, "act/365");*act/365' utilise le nombre réel de jours entre les dates pour calculer le nombre d'années (calculé par le nombre de jours divisé par 365);

jourdif1=datdif(date_sas, ajd1, "act/act"); *IMPORTANT ici on est obligé de préciser la méthode utilisé par la fonction, contrairement à la fonction yrdif + on calcul le nombre de jour sans prendre en compte les années !;
jourdif2=datdif(date_sas, ajd1, "30/360"); *SAS ne prend en compte que deux méthode pour la fonction datdif contre quatre pour yrdif;
jourdif3=datdif(date_sas, ajd1, "act/360");
jourdif4=datdif(date_sas, ajd1, "30/360");

anneedif5=intck("year", date_sas, ajd1);*on fixe un intervalle de 1 an a calculer, on constate qu'il n'y a pas d'arrondit;
jourdif5=intck("day", date_sas, ajd1);*'day', 'weekday', 'week', 'month', 'qtr', and 'year' sont des exemples d'intervalles valides;

moisdif_paire1=intnx("month",date_sas, 2); * on observe que sas nous retourne automatiquement la première date du deuxième mois après le mois de sas_date;
moisdif_paire2=intnx("month",date_sas, 2, "beginning"); * idem !;
moisdif_paire3=intnx("month",date_sas, 2, "middle");
moisdif_paire4=intnx("month",date_sas, 2, "end");
moisdif_paire5=intnx("month",date_sas, 2, "sameday");

semainedif=intck("week", date_sas, intnx("month",date_sas, 2, "sameday"));

format moisdif_paire1-moisdif_paire5 date9.;

run;

proc print data=date3 (obs=5);
var date_sas ajd1 anneedif anneedif1-anneedif4 jourdif1-jourdif4 ;
run;

proc print data=date3 (obs=5);
var date_sas ajd1 anneedif5 jourdif5 semainedif moisdif_paire1-moisdif_paire5;
run;

/***************************************************/

*une autre manière de sockés nos dates alimenter une variable macro GLOBALE;
%let annee=2020; *on stock "2020" dans annee;
%put le contenu de annee est &annee.; *on fait appel à annee dans une chaine de charactere grace a %put;
%let anneesuivante=%eval(&annee.+1); *%eval nous permet dutiliser des elements de logique, ici + ;
%put le contenu de anneesuivante est &anneesuivante.; *on constate que 2021;
%let chainedecar=ceci est une chaine de caracteres; *on stock une chaine de caractere;
%put le troisieme mot de chainedecar est %substr(&chainedecar.,14,6); *on utilise une autre fonction macro %substr;

*une autre manière d'allimenter une vaiable macro= callsymputx pour acceder a de l'info dans une table de données;

%macro Total;
proc summary data = date3; *on additionne toutes les observations de la variable du total dhospitalisation;
		var ACT_Total_RSS99;
		output out = somme (drop = _:) sum=;
run;

data _null_; *cet etape data nous permet de sotcker notre resultat dagregation dans des variables macros grace a call symput;
		set somme;
		call symputx("nb_covid_total1", put(ACT_Total_RSS99, 8.), "G");* Global;
		call symputx("nb_covid_total2", put(ACT_Total_RSS99, 8.), "L");* Local;
		call symput("nb_covid_total3", put(ACT_Total_RSS99, 8.));
run;
%put nombre total de personnes hospitalisees au quebec = &nb_covid_total3.;
%mend Total;

%Total

%put nombre total de personnes hospitalisees au quebec1 = &nb_covid_total1.;
%put nombre total de personnes hospitalisees au quebec2 = &nb_covid_total2.;
%put nombre total de personnes hospitalisees au quebec3 = &nb_covid_total3.;

*on est maintenant en mesure de créer des macros plus complexes, 
on peut permettre à l'utilisateur d'insérer la variable qu'il préférer consulter, 
par défaut la macro donnera le même résulats que précédement;

%macro Total_var(var=ACT_Total_RSS99);
proc summary data = date3;
	var &var.; *on ajoute notre variable macro ici enfonction de laquelle nos donnees seront aggreger;
	output out = somme (drop = _:) sum=;
run;

data _null_;
		set somme;
		call symputx("nb_covid_total_var1", put(&var., 8.), "G");* Global;
run;

%put nombre total de personnes hospitalisees sur &var. = &nb_covid_total_var1.;
%mend Total_var;

%Total_var();

%Total_var(var=ACT_Total_RSS99); *on constant que le résulatat est le même !;

%Total_var(var=ACT_Hsi_RSS99);

%Total_var(var=ACT_Si_RSS99);

*maintenant, on aimerait connaître avec plus de détails certaines périodes;
*ici on va permettre à l'utilisateur de sélectionner une date précise;
%macro date(date=, var=ACT_Total_RSS99);

data test;*on selectionne lobservation liee a la date entree en argument;
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
%put nombre total de personnes touchées par le covid le &date. = &nb_covid_jour.;
%mend date;

%date(date=18FEB2021);

*nous voulons également permettre à l'utilisateur de consulter un intervalle de temps;

%macro intervalle(debut=,fin=,var=ACT_Total_RSS99,aug=0);

proc sort data=date3 out=test; by date_sas; run;*nous trions les donnees avant notre etape data en raison de la fonction lag dont on va avoir besoin;

data test;
set test;
if "&debut."d <= date_sas <= "&fin."d; *nous permet de selectionner un intervalle dans le jeu de donnee original;
augm=&var.-lag(&var.);*nous permet de calculer la difference entre deux date de la variable;
run;

proc summary data = test;
	%if &aug. = 0 %then %do; *cet ennnonce conditionnel permet de configurer le proc summaray en fonction de laugmentation ou non;
	var &var.;
	output out = somme (drop = _:) sum=&var. %end;
	%else %if &aug. = 1 %then %do;
	var augm;
	output out = somme (drop = _:) mean=augm %end;;
run;

data _null_;
		set somme;
		%if &aug. = 0 %then %do; *cet ennonce conditionnel nous permet de stocker dans une variable macro le resultat de notre agregation en fonction de laugmentation ou non;
		call symputx("somme", put(&var., 8.), "G"); %end;* Global;
		%if &aug. = 1 %then %do;
		call symputx("moyenne", put(augm, 8.), "G"); %end;;* Global;
run;

%if &aug. = 0 %then %do; *nous affichons les resultats en fonction de la valeur de aug;
%put nombre total de personnes hospitalise par le covid entre le &debut. et le &fin. pour la variable &var. = &somme.;%end;
%if &aug. = 1 %then %do;
%put nombre moyen de personnes hospitalise par le covid entre le &debut. et le &fin. pour la variable &var. = &moyenne.;%end;

PROC SGPLOT DATA = test;*ici on ne veut pas supperposer deux courbes, si var est equivalente a la variable de reference notre macro permet de ne produire quune seule courbe;
%if &var.= ACT_Total_RSS99 %then %do;
SERIES Y = &var. X = date_sas; %end;
%else %if &var. ne ACT_Total_RSS99 %then %do;
SERIES Y = ACT_Total_RSS99 X = date_sas;
SERIES Y = &var. X = date_sas; %end;
RUN;

%mend intervalle;

%intervalle(debut=10FEB2021,fin=19MAR2021,var=ACT_Si_RSS99,aug=0)

%intervalle(debut=10FEB2021,fin=19MAR2021,var=ACT_Total_RSS06,aug=1)


%macro intervalle2(debut=,fin=,var=ACT_Total_RSS99,aug=0, int=day);

proc sort data=date3 out=test; by date_sas; run;

data test;
set test (where =("&debut."d <= date_sas <= "&fin."d));
augm=&var.-lag(&var.);
int=intck("&int.",date_sas,"&debut"d)*-1;*ici nous calculons la difference sur un certain intervalle identifie en commentaire;
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
	%if &var.= ACT_Total_RSS99 %then %do;*au lieu d'utiliser la date sas comme precedememnt on utilise notre nouvelle variabe int;
		SERIES Y = &var. X = int; %end;
	%else %if &var. ne ACT_Total_RSS99 %then %do;
		SERIES Y = ACT_Total_RSS99 X = int;
		SERIES Y = &var. X = int; %end;
RUN;

%mend intervalle2;

%intervalle2(debut=10NOV2020,fin=25JAN2021,var=ACT_Total_RSS99,int=weeks)

%intervalle2(debut=10NOV2020,fin=25JAN2021,var=ACT_Total_RSS06,aug=1,int=weeks)
