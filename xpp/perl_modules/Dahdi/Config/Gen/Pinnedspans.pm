package Dahdi::Config::Gen::Pinnedspans;
use strict;

use Dahdi::Config::Gen qw(is_true);

sub new($$$) {
	my $pack = shift || die;
	my $gconfig = shift || die;
	my $genopts = shift || die;
	my $file = $ENV{PINNED_SPANS_CONF_FILE} || "/etc/dahdi/pinned-spans.conf";
	my $self = {
			FILE	=> $file,
			GCONFIG	=> $gconfig,
			GENOPTS	=> $genopts,
		};
	bless $self, $pack;
	return $self;
}

sub generate($$$) {
	my $self = shift || die;
	my $file = $self->{FILE};
	my $gconfig = $self->{GCONFIG};
	my $genopts = $self->{GENOPTS};
	my @spans = @_;
	warn "Empty configuration -- no spans\n" unless @spans;
	rename "$file", "$file.bak"
		or $! == 2	# ENOENT (No dependency on Errno.pm)
		or die "Failed to backup old config: $!\n";
	#$gconfig->dump;
	print "Generating $file\n" if $genopts->{verbose};
	my $cmd = "span_assignments dumpconfig > $file";
	system $cmd;
	die "Command failed (status=$?): '$cmd'" if $?;
}

1;

__END__

=head1 NAME

dahdi - Generate configuration for dahdi drivers.

=head1 SYNOPSIS

 use Dahdi::Config::Gen::Dahdi;

 my $cfg = new Dahdi::Config::Gen::Dahdi(\%global_config, \%genopts);
 $cfg->generate(@span_list);

=head1 DESCRIPTION

Generate the F</etc/dahdi/pinned-spans.conf>.
This is the configuration for span_assignments.

Its location may be overriden via the environment variable F<PINNED_SPANS_CONF_FILE>.
