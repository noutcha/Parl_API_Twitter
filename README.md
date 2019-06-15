Utiliser Twitter, obtenir des Tweets à partir d'un scrip Perl
====================
[![Build Status - Master](https://travis-ci.org/noutcha/Perl_API_Twitter?branch=master)](https://travis-ci.org/noutcha/Perl_API_Twitter)
[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Project Status](http://opensource.box.com/badges/maintenance.svg)](http://opensource.box.com/badges)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/major/Perl_API_Twitter.svg)](http://isitmaintained.com/project/noutcha/Perl_API_Twitter "Average time to resolve an issue")
[![Percentage of open issues](http://isitmaintained.com/badge/open/noutcha/Perl_API_Twitter.svg)](http://isitmaintained.com/project/noutcha/Perl_API_Twitter "Percentage of issues still open")
[![GPL License](https://badges.frapsoft.com/os/gpl/gpl.png?v=103)](https://opensource.org/licenses/GPL-3.0/)


Déscription
============
Avez-vous eu l'idée d'une application qui gagnerait à obtenir des données sur un compte Twitter? 
Dans cet exemple, nous verrons comment configurer votre compte Twitter pour pouvoir le faire, 
et comment écrire un srcipt en perl pour obtenir les Tweets à l'aide de Net::Twwitter (https://metacpan.org/pod/Net::Twitter).)

Ne vous inquiétez, je l'ai écrit pour vous!

Conditions préalables
=====================

Vous deviez installer les packages suivants :
* [Net::Twitter](https://metacpan.org/pod/Net::Twitter)
* [Config::Tiny](https://metacpan.org/pod/Config::Tiny)
* [Fichier::HomeDir](https://metacpan.org/pod/File::HomeDir) 
* [utf8::all](https://metacpan.org/pod/utf8::all)

**Vous devez** vous abonner sur le compte twitter [@CERT_FR](https://twitter.com/CERT_FR) .

Net::Twitter ?
------------ 
C'est une interface Perl pour l'API Twitter.
Pour plus d'informations visiter le site [Meta CPAN](https://metacpan.org/pod/Net::Twitter) .

Example : Publier un Tweet
------
Cet exemple est disponible sur le site CPAN qui donne plus de details sur cette interface.


```perl

use Net::Twitter;
use Scalar::Util 'blessed';
 
# Quand aucune authentification n'est requise:
my $nt = Net::Twitter->new(legacy => 0);
 
# À partir du 13 août 2010, Twitter requiert OAuth pour les demandes authentifiées.

my $nt = Net::Twitter->new(
    traits   => [qw/API::RESTv1_1/],
    consumer_key        => $consumer_key,
    consumer_secret     => $consumer_secret,
    access_token        => $token,
    access_token_secret => $token_secret,
);
 
my $result = $nt->update('Hello, world!');
 
eval {
    my $statuses = $nt->friends_timeline({ since_id => $high_water, count => 100 });
    for my $status ( @$statuses ) {
        print "$status->{created_at} <$status->{user}{screen_name}> $status->{text}\n";
    }
};
if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('Net::Twitter::Error');
 
    warn "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "Twitter error.....: ", $err->error, "\n";
}

```

Si vous souhaitez des petits exemple de codes qui pourront enrichir votre
boite a outils de developreur, regardez les sources de mon depot.

Autres exemples et documentation
==========================

Pour plus de détails et des exemples de code, consultez 
la page de démonstration et de documentation sur: https://metacpan.org/pod/Net::Twitter

Construire à partir de la source
================================
Pour créer Perl_API_Twitter à partir des sources, vous aurez simplement besoin d’un utilitaire make et de Perl 5.8 ou plus récent. 
Pour obtenir et compiler automatiquement Perl_API_Twitter, vous aurez peut-être également besoin d'un client git.

Pour obtenir le Perl_API_Twitter directement à partir de son dépôt:

```cmd

	>git clone git://github.com/noutcha/Perl_API_Twitter.git

```
La procédure d’exécution
========================
Pour exécuter le programme (en considérant que perl est déjà installer sur votre PC).
Si c'est n'est pas le cas, visitez la page [Installing Perl on Windows (32 and 64 bit)](https://learn.perl.org/installing/windows.html) 
1)	Décompressez le fichier Suivi_vulnerabilite.zip sur votre disque local
2)	Placez-vous dans ce dossier décompressé et ouvrez l’invite de commande à cet endroit
3)	Tapez la commande >perl vulnerabilitesCERT_FR.pl.

License
======
Double licence sous les licences MIT ou GPL version 2.



Michel Gildas NOUTCHA

