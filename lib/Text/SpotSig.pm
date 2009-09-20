package Text::SpotSig;

use strict;
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

__END__
