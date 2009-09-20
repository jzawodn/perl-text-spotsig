package Text::SpotSig;

use strict;
use warnings;
use Exporter;

our $VERSION = '0.1';

our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();
our %EXPORT_TAGS = ();

1;

my @default_stopwords = qw(the an and or as of am your we a if is to our his her in);

sub new {
	my $class = shift;

	my $self = {
		foo       => 1,
		debug     => 0,
		regex     => undef,
		stopwords => [@default_stopwords],
	};

	return bless $self, $class;
};

## set stopwords to the list we're passed

sub set_stopwords {
	my $self = shift;
	my $ref  = shift;

	if (ref($ref) eq 'ARRAY') {
		$self->{stopwords} = $ref;
	}
	$self->{regex} = undef;
}

## perform analysis on text that we're passed

sub analyze {
	my $self = shift;
	my $text = shift;
	my @sigs = ();

	## clean the text up, removing everything except word characters
	## and basic punctuation.

	my %stopword = map { $_ => 1 } @{$self->{stopwords}};
	my $sig;
	my $cnt = 0;

	## find the sigs
	while ($text =~ m/(\w+)/g) {
		my $word = lc $1;
		print STDERR "word: $word\n" if $self->{debug};

		if ($stopword{$word}) {
			if (defined $sig) {
				if ($cnt > 1) {
					push @sigs, $sig;
					print STDERR "sig : $sig\n" if $self->{debug};
				}
				$sig = undef;
				$cnt = 0;
			}
			$sig = $word;
			$cnt++;
		}
		else {
			if (defined $sig) {
				$sig .= " $word";
				$cnt++;
			}
		}
	}

	## any left?
	if (defined $sig) {
		if ($cnt > 1) {
			push @sigs, $sig;
			print STDERR "sig : $sig\n" if $self->{debug};
		}
	}

	return \@sigs;
}

sub version {
	my $self = shift;
	return $VERSION;
}

=head1 NAME

Text::SpotSig - Perl extension making SpotSigs

=head1 SYNOPSIS

  use Text::SpotSig;

  my $ss = new Text::SpotSig;
  my $text = "the quick brown fox jumped over the lazy dog";
  my $sigs = $ss->analyze($text);

  print "Found: " scalar(@$sigs) . " total sigs in the text\n";

=head1 DESCRIPTION

SpotSigs are a method of fingerprinting documents in a large
collection for the purpose of finding duplicates or near duplicates.
The basic method is to read the document, creating a new signature
each time you encounter a stop word.

To use the example above, the text "the quick brown fox jumped over
the lazy dog" would produce two signatures using the default stop word
list: 'the quick brownf ox jumped over' and 'the lazy dog'.

I highly reccomend you read the paper referenced below for more
details on how spotsigs can be used.  This module merely makes it
easier to produce spotsigs.  Analysis and use of them is currently up
to you, since the use cases will likely vary quite a bit.  In the
future this package may contain code that helps with that.

=head2 METHODS

TODO: write this

=head2 EXPORT

None by default.

=head1 SEE ALSO

SpotSigs were first described here:

http://dbpubs.stanford.edu/pub/2008-10
http://infoblog.stanford.edu/2008/08/spotsigs-are-stopwords-finally-good-for.html
http://ilpubs.stanford.edu:8090/860/

The soruce code for this module is hosted on GitHub:

http://github.com/jzawodn/perl-text-spotsig

=head1 AUTHOR

Jeremy Zawodny, E<lt>Jeremy@Zawodny.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Jeremy Zawodny

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

__END__
