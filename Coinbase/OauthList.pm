package Coinbase::OauthList;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/oauth/applications';
use constant ATTRIBUTES   => qw(page);
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub page         { my $self = shift; $self->get_set(@_) }
sub url          { URL          } 
sub request_type { REQUEST_TYPE }
sub is_ready     { READY        }

1;

__END__

