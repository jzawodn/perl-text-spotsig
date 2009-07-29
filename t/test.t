#!/usr/bin/perl -w

use strict;
use lib '../lib';
use lib 'lib';
use Test::Simple tests => 5;
use Text::SpotSig;
use Data::Dumper;

my $ss = new Text::SpotSig;
my $text;
my $sigs;
my $verbose = 0;

ok($ss->version > 0, 'version');


## test 1

$text = "the quick brown fox jumped over the lazy dog";
$sigs = $ss->analyze($text);

if ($verbose) {
	print "text: $text\n";
	print Data::Dumper->Dump([$sigs]), "\n";
}

ok(1, 'simple');

## test 2

$text = "Luke.  I am your father.  Together we will rule the universe!";
$sigs = $ss->analyze($text);

if ($verbose) {
	print "text: $text\n";
	print Data::Dumper->Dump([$sigs]), "\n";
}

ok(1, 'star wars');

## test 3: consitution preamble

$text = qq{We the People of the United States, in Order to form a more perfect Union, establish Justice, insure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessings of Liberty to ourselves and our Posterity, do ordain and establish this Constitution for the United States of America.};
$sigs = $ss->analyze($text);

if ($verbose) {
	print "text: $text\n";
	print Data::Dumper->Dump([$sigs]), "\n";
}

ok(1, 'consitution preamble');

## test 4: lord's prayer
$text = qq{    Our Father in heaven,

        hallowed be your name,
        your kingdom come,
        your will be done,

            on earth as in heaven.

    Give us today our daily bread.
    Forgive us our sins

        as we forgive those who sin against us.

    Save us from the time of trial

        and deliver us from evil.

    For the kingdom, the power, and the glory are yours

        now and for ever. Amen.
};
$sigs = $ss->analyze($text);

if ($verbose) {
	print "text: $text\n";
	print Data::Dumper->Dump([$sigs]), "\n";
}

ok(1, "lord's prayer");

exit;

__END__
