package Coinbase::OauthNew;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/oauth/applications';
use constant ATTRIBUTES   => qw(application);

sub application  { my $self = shift; $self->get_set(@_) }
sub attributes   { ATTRIBUTES }
sub url          { URL } 
sub is_ready     { defined shift->application }

1;

__END__

