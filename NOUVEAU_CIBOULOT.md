# Vision 

Plateforme «légère» de rédaction de matériel de cours:

1. Deux serveurs publics
	* Serveur GIT
	* Serveur HTTP + appli HTLM5

1. Une application locale
	* Serveur local + appli HTLM5

1. Des outils locaux
	* Tout est fait par fichier, alors les outils sont «aux choix»
	* Un peu comme un SDK avec des outils «ligne de commande»
	* On peut aussi imaginer un genre de IDE (soit dans le navigateur, soit en Java -- genre plug-in d'Eclipse)

1. (à vendre?): version infonuagique des «outils locaux». Moins flexible, mais plus «clé en main»
	* c'est une gros ??? ... parce que le libre fonctionne mieux «en petit»

En fait, l'objectif est de garder le matériel ouvert:

* Facile de créer sa propre version du cours
* Fichiers textes: liberté d'utiliser ses propres outils, voire d'en créer des nouveaux

# Volet entreprise (ou OSBL?)

1. Vendre du développement
	* de matériel
	* de schéma
	* d'outils locaux ou de plugin (p.ex. pour se connecter au serveur LDAP de l'organisation)
1. Vendre des éditions papier (via .tex), genre «cahier de cours»
1. Vendre des formations basées sur le matériel disponible en-ligne
	* genre de «guilde» ou coopérative de formateurs
	* pour le matériel, serait sympa de collaborer avec des pros ayant de l'expérience avec la matiére de la formation (serait une plus value)
1. Vendre du support (help-desk) ?

# Étapes de développement

## D'abord: pour moi

 Porter attention au fait que GIT servira à collaborer (p.ex. adapter les formats .md, .yaml pour que git diff fonctionne bien)

1. Nouveau format Markdown, on veut:
	* des notions de scope mieux définis, p.ex avec des {} explicites
		* mettre l'accent sur la segmentation (section, paragraphe) comme la base pour avoir plusieurs vu
        * potentiellement du CSS pour chaque segment (écrire dans un .meta-css qui s'applique dynamiquement à des segements)
	* notion de namespace et d'identifiant pour faciliter les liens
		* i.e. plutôt que ../../../proc/virsh_creer_vm    on veut     @proc/virsh/creer_vm  ou encore proc.virsh.creerVM
		* surtour: le «chemin» est via le namespace, pas le chemin en fichier

	* table des matières, index de notions, on veut que le cours soit facile à explorer, naviguer
	* des TAGS dans les fichiers?
	* recherche


1. Format .yaml pour 
	* tableau
	* schéma «intéractif»


1. Serveur public de base
	* afficher les fichiers, c'est tout

1. Serveur local de base
	* rafraîchissement automatique
	* afficher des erreurs
	* modification des schémas avec la souris
	* complétion et sélection facile
	* des «preview» (images, liens)

## Ensuite: pour les étudiants

Serveur et appli local permettant aux étudiants d'étider le matériel.

En particulier:

* Le serveur local prend en charge les interactions GIT
* L'appli locale présente une version simplifié de GIT (p.ex seulement deux branches: «prof» et «étudiant» et seulement une opération de sync avec le serveur)

## Finalement: pour d'autres profs

Si on veut collaborer avec d'autres profs, il faut d'abord que ça soit suffisement facile d'utilisation pour les édutiants.

Les nouveaux profs sont habituellement réticent à apprendre de nouvelle façon de faire.


# Architecture

* En Java: 
	* serveur public
	* serveur local 

* En JS (React?)
	* client HTML5

* App Android (serveur local + client en WebView)

## Public Vs local

* Serveur d'affichage
	* Seule la branche master est servie par HTTP

* Serveur GIT public
	* Serveur GIT «normal» + peut-être gestion de droits d'accès
		* P.ex. les «examens» ne sont pas réellement publics

* Toute la collaboration se fait par GIT
	* Pour devenir un collaborateur, il faut installer
          le serveur local, puis travailler en local et pousser via GIT
	* chaque collaborateur a sa branche


## Scénario d'utilisation de GIT

Étudiant:

* Télécharge le serveur local
* Lancer l'application Web en «mode local» (connectée au serveur local)
* Le serveur fait un git pull de la branche correspondant à l'étudiant
* L'étudiant peut modifier le contenu et/ou prendre des notes

Conséquence d'utiliser GIT:

* Pour corriger une coquille, le serveur de l'étudiant fera un git pull master
* Sauf que ça pourrait créer des conflits avec les modifs de l'étudiant
* Alors il faut que l'app locale affiche un DIFF et permette de facilement résoudre les conflits

Idée:

* Le serveur 


En particulier, le format .md modifié doit rester «ligne par ligne» pour que GIT fonctionne bien

Si l'étudiant ajoute un commentaire, alors la ligne originale doit restée la même sinon on va créer un conflit 

P.ex pour un commentaire, on va écrire une ligne avant la section commentée (phrase ou paragraphe)


		[wer3: un commentaire]
		Une phrase qui fera l'objet d'un commentaire









# Nouveau ciboulot

## Leçons de l'ancien ciboulot

Ce qui fonctionne bien:

* Contenu simple en .md
* Pousser avec git
* Intégrer des extraits de code Java
* Rapide
* Procédures par étape

Ce qui fonctionne mal:

* Pas de PDF, pas de HTML statique (et donc la recherche est pas super)
* Éditer plusieurs fichiers est parfois pénible
	* p.ex. 5-6 fichiers pour une procédures à multiples étapes
* Ordre aléatoire dans liste de procédure (dépend de l'ordre réseau)
* Collaboration: on aurait besoin d'une interface Web

## Mes cours

* ZB5: labos en une page
* Android/513:  labos en une page + extrait de code + un peu de procédure par étapes
* 3B6: labos en une page + plusieurs procédures (à mettre à jour)

# Liste de souhaits

* Deux versions PDF de chaque document:
	* PDF à imprimer
	* PDF à lire à l'écran
* Une version HTML statique à sauvegarder (les étudiants aiment garder la doc)

* Mieux structurer en petits segments
	* Indexé par thème, par semaine de cours, etc.
   
* CSS qui change d'une page à l'autre
    * En fait, écrire dans un .meta-css: scope sélecteur{} (le scope est le segment auquel la règle s'applique)

* On veut:
	1. Pour l'éditeur: 
	1. Intermédiaire: la structure hierarchique + des liens
	1. Afficher: linéaire et/ou interactivité

* Génération du calendrier avec date à partir du calendrier «abstrait»

* Possibilité de login (éventuellement pour des examens)

* Backend: tout en fichiers et en GIT (éventuellement avec du cache etc.)
           plug-in VIM pour l'édition des fichiers
* Fontend: un petit éditeur, genre IDE (qui affiche des listes de suggestions)
           colorification et correction, mais on garde simple

* Mode édition: le matériel se met à jour dès qu'on sauvegarde le fichier.
                le navigateur défile jusqu'à la section modifiée

# Détails d'implémentation

* Chaque ressource à son identifiant
* On peut déclarer un namespace dans le fichier (namespace labo1)
	* Puis à l'intérieur de ce namespace, chaque ressource (p.ex. une section) a son nom (labo1.afaire)

* Le serveur «compile» les fichiers et conserve la structure en mémoire (p.ex. liste de namespace et d'identifiant)

# Vision

On a plusieurs «vues» sur le même matériel:

* Présentations magistrales
* Énoncés de labo
* Rapport de labo

L'étudiant peut toujours naviguer d'un concept à l'autre.

L'information est toujours présentée par petit bout.


## Rapport de labo

L'énoncé de labo est à remplir directement en-ligne (en répondant aux questions, en

À la fin, l'étudiant soumet et demande la validation de l'enseignant


## COOP d'enseignement libre de l'informatique

* Promotion du libre dans l'enseignement
* Dévelopement de la plateforme ciboulot (seeboolow.com)
* Contrats de formation (avec du matériel déjà existant et disponible)
* Hébergement payant de la plateforme (pour les institutions qui ne veulent pas héberger eux-même)











































