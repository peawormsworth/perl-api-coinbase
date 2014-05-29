package Coinbase::Addresses;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/addresses';
use constant ATTRIBUTES   => qw(page limit account_id query);
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub page         { my $self = shift; $self->get_set(@_) }
sub limit        { my $self = shift; $self->get_set(@_) }
sub account_id   { my $self = shift; $self->get_set(@_) }
sub query        { my $self = shift; $self->get_set(@_) }
sub url          { URL          } 
sub request_type { REQUEST_TYPE }
sub is_ready     { READY        }

1;

__END__

