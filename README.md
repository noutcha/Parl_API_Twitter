Utiliser Twitter, obtenir des Tweets à partir d'un scrip Perl
====================
[![Build Status - Master](https://github.com/noutcha/Perl_API_Twitter?branch=master)](https://travis-ci.org/noutcha/Perl_API_Twitter)
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
Fichier::HomeDir
Config::Minuscule
Net::Twitter

Net::Twitter ?
------------ 
C'est une interface Perl pour l'API Twitter.
Pour plus d'informations visiter le site [Meta CPAN](https://metacpan.org/pod/Net::Twitter),

Example
------
Cet exemple est disponible sur le site CPAN qui donne plus de details sur cette interface.
```html
<div id="webcam"></div>
```

```javascript

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

License
======
Double licence sous les licences MIT ou GPL version 2.

