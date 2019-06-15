#!/usr/bin/perl
#
#======================================================================
# Auteur: Michel Noutcha  <michel.noutcha@student.uclouvain.be>
# Date : 11/06/2019
# Version : 1.0
#======================================================================
# Ce programme doit recuperer les tweets qui sont en quelque sorte les vulnerabilités publiées par le CERT_FR 
# Sur son compte @CERT_FR, puis doit extraire juste les vulnérabilité propres aux systèmes Microsoft/windows.
# Doit generer deux fichiers un fichier de toutes les vulnerabilités et l'autre de vulnerabilités des produits Microsoft windows. 
# Pas de paramtre mais.
#======================================================================
# Exemple :
# perl vulnerabilitesCERT_FR.pl
#======================================================================
#
use utf8; #dire à Perl que le code source est codé avec UTF-8
use open ':std', ':encoding(UTF-8)'; #dire à Perl comment encoder notre texte pour les données stoquée dans les fichiers
use open 'IO', ':encoding(UTF-8)'; #dire à Perl comment encoder notre texte pour les données stoquée dans les fichiers

binmode ('OUT', ":utf8"); #dire à Perl comment encoder notre texte pour les données affichées sur la console


use Scalar::Util qw/blessed/; #contient une sélection de sous-routines que les gens ont exprimées
use Net::Twitter; # interface Perl pour l'API Twitter
use File::Spec; # Effectue des opérations sur les noms de fichiers. en fonction de votre systeme vous pouvez 
				#conçu pour prendre en charge les opérations couramment effectuées sur les spécifications de fichier
use Storable; 	# module de persistance pour les structures de données Perl. 
				#c'est-à-dire tout ce qui peut être commodément stocké sur le disque et récupéré ultérieurement
				
use Data::Dumper; # Pour afficher la Structures de données Perl 
use File::HomeDir; # module permettant de localiser les répertoires "détenus" par un utilisateur

use warnings;	#donne le contrôle sur quels avertissements sont activés dans quelles parties du programme Perl. avertissements 
use strict;		# désactive certaines expressions Perl qui pourraient se comporter de manière inattendue ou 
				#qui sont difficiles à déboguer, ce qui les transforme en erreurs.(Par exemple declaration double d'une meme variable)

#Variables utiles pour notre programme

# On definie notre fichier de donnée brute
my $rawData = "AllvulnerabilitesCERT_FR.txt";
my $processedData  = "MicrosoftvulnerabilitesCERT_FR.txt";

# On ouvre le fichier de donnée 
open( my $rawData_fh, '+>', $rawData )
	or die("Impossible de trouver d'ouvrir $rawData en écriture\n");
  
open( my $processedData_fh,  '+>', $processedData )  
	or die("Impossible d'ouvrir le fichier $processedData\n");
	
# my $nt;
# my %consumer_tokens;
# my $datafile; 
# my $access_tokens;
# my $auth_url;
# my $pin
 
# Si vous avez les clés d'un api twitter vous pouvez le remplacer par les votres

# Creation de notre tableau( table de hachage) pour le stockage des données d'accès a l'API
my %consumer_tokens = (
    consumer_key    => 'V4y8PXYLRaLBPi1yodkSDs2mW',
    consumer_secret => 'e9ybTukfvEHQheoXu9X62dxpxzdNvOeaM1tnw5NOUBd2uDk24N',
);

 
# $datafile = vulnerabilitesCERT_FR.dat # Nom du fichier qui doit sauvegarder sur notre disque 
				#la session active(jusqu'a la fermeture de la console)
my (undef, undef, $datafile) = File::Spec->splitpath($0); #Divise un chemin en parties de volume, 
				#de répertoire et de nom de fichier.
				# undef, undef($/ = undef), $datafile sont respectivement les variable qui vont stoquer 
				#le volume, le dossier et le nom du fichier en cours d'execution
$datafile =~ s/\..*/.dat/;  # Pater pour le nom du fichier de données de connexion, on elimine les espace si existants
 
my $nt = Net::Twitter->new(traits => [qw/API::RESTv1_1/], %consumer_tokens); # Creation de notre object api Net::Twitter ici la version 1.1 
my $access_tokens = eval { retrieve($datafile) } || [];
 
if ( @$access_tokens ) { # Si les information de connexion existe deja on passe ces informations a notre objet netTwitter($nt)
    $nt->access_token($access_tokens->[0]);
    $nt->access_token_secret($access_tokens->[1]);
}
else { #Si non On la créee
    my $auth_url = $nt->get_authorization_url; # On recuper le lien d'autorisation d'accés
	my $info =" Autoriser cette application à acceder à l'application \n Copier et coller le lien Suivant dans votre navigateur pour optenir le code PIN: $auth_url\nEnsuite, entrez le code PIN# fourni pour continuer: ";
    println($info) ;
 
    my $pin = <STDIN>; # On attend la saisie du code PIN
    chomp $pin; #nous permet d'éviter \n(retour de ligne) sur le dernier champ
 
	#request_access_token stocke les jetons dans $nt et les renvoie
    my @access_tokens = $nt->request_access_token(verifier => $pin); # Si le PIN fourni est correct
 
    # On enregistre les jetons d'accès dans le fichier qui porte le nom vulnerabilitesCERT_FR.dat
    store \@access_tokens, $datafile;
}



# user_timeline: Renvoie les 20 états les plus récents publiés par l'utilisateur authentifiant. 
				#Il est également possible de demander la chronologie d'un autre utilisateur 
				#via le paramètre id. C'est l'équivalent de la page Web / archive pour votre propre 
				#utilisateur ou de la page de profil pour un tiers (grace à son pareamètre screen_name) .

#eval(block eval) nous l'utilisons capturer les erreurs éventuelles 
				#afin qu'elles ne bloquent pas le programme
				
eval { #vérifier si la fonctionnalité user_timeline donnée est disponible avec notre obejct $nt.
	local  $@ ;  # protège le $@ existant
    my $statuses = $nt->user_timeline({screen_name => "CERT_FR", count => 3000}); #screen_name nous permet de specifier qui on veux extraire les tweets
    for my $status ( @$statuses ) {
        #print("$status->{created_at} <$status->{user}{screen_name}> $status->{text}\n\n");

		my $data ="$status->{created_at} <$status->{user}{screen_name}> $status->{text}";
		chomp $data;
		print $rawData_fh "$_\n" for $data; # charegemnt des données brutes dans le fichier 	
    }
	
	#Block d'appel des fonctions
		println("");
		AfficheInfo();
		AfficheHeader();

			foreach my $status (@$statuses ) {

					 #print $string;    CERTFR-2019-AVI-105   (^[1-8]-?[A-Z][A-Z][A-Z]-[0-9][0-9][0-9]$)
					 #   $status->{text} =~ "(^[C-T]{6}-?)|(^)" and $status->{text} =~ /Microsoft/
					 #$status->{text} =~ "(^([C-T]{6}-?|[A-Z]))" and $status->{text} =~ /Microsoft| Windows/
					 if ($status->{text} =~ "(^([C-T]{6}-?|[A-Z]))" and $status->{text} =~ /Microsoft| Windows/) {
					 #print "OUI\n";
					my $dataSort ="$status->{created_at} <$status->{user}{screen_name}> $status->{text}";
					
					chomp $dataSort;
					print $processedData_fh "$_\n" for $dataSort; # charegemnt des données brutes(vulnerabilités et alerte, Misajour concernant Microsof) dans le fichier
					 
					AfficheData($status);
					
					 
					 }
					 else {
					 #print "NON\n";
					 }
			 }
}; #en cas d'erreur de syntaxe ou une erreur d'exécution definie $@ contenant les message d'erreur
if ( my $err = $@ ) { # si $@ est definie alors on a une erreur, on la recupère et affiche
    die $@ unless blessed $err && $err->isa('Net::Twitter::Error');
 
    warn "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "Twitter error.....: ", $err->error, "\n";
}
AfficheFooter();



# les fonctions utiles 

#permet d'afficher les données avec retour a la ligne
sub println {
		my $texte = $_[0];
		print $texte . "\n\n";
 };
 
sub AfficheHeader {
		println("=========================================================================================================================================================================================================================||");
		println("======================= ALERTE DE VULNÉRABILITÉS DANS LES SYSTÈMES MICROSOFT DU CERT FR ==============================================================================================================================||");
		println("  Date et heure \t\t\t Auteur \t\t\t\t\t\t\t\t Vulnérabilités et sources \t\t\t\t\t\t\t\t\t\t\t ||");
		println("======================================================================================================================================================================================================================== ||");
 }; 
 
 sub AfficheFooter {
		println("=========================================================================================================================================================================================================================||");
		println("====================== Programme developé par Michel NOUTCHA étudiant en Master STIC UCL ==============================================================================================================================||");
		# println("   \t\t\t\t\t\t ||");
		println("======================================================================================================================================================================================================================== ||");
 };


 sub AfficheInfo {
		println("=========================================================================================================================================================================================================================||");
		println("============================================= BIENVENUE DANS CE PROGRAMME ===========================================================================================================================================||");
		println("\t\t\t  Ce programme met à votre disposition, les vulnérabilités les plus ressentes publiées par le CERT Fr. sur son compte twitter\n \t\t\t  concerant les systèmes Microsoft/windows. Pour consulté toutes les vulnérabilités publiées par CERT-FR nous vous conseillons\n \t\t\t de consulter le fichier << $rawData >>\n \t\t\t  généré par ce programme et mis à jour à chaque execution.\n \t\t\t
		Nous vous recommandons aussi vivement de consulter le fichier << $processedData >> contenant les vulnerabilités\n \t\t\t et Alerts propre aux systèmes Microsoft généré par ce programme et mis à jour à chaque execution.  \t\t\t
		\n \t\t\t \n \t\t\t \t\t\t BONNE UTILISATION \n\n \t\t\t\t\t\t Pour toutes questions : michel.noutcha\@student.uclouvain.be \t\t\t\t\t\t\t\t\t\t\t\t\t\t ||");
		println("======================================================================================================================================================================================================================== ||");
 }; 
 


sub AfficheData {
		my $status = $_[0];
		println("$status->{created_at} \t\t <$status->{user}{screen_name}> \t\t $status->{text}");
 }; 
 

#Fermèture des fichiers
close($rawData_fh);
close($processedData_fh);