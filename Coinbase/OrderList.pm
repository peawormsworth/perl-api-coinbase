package Coinbase::OrderList;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/orders';
use constant ATTRIBUTES   => qw(account_id page);
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub account_id   { my $self = shift; $self->get_set(@_) }
sub page         { my $self = shift; $self->get_set(@_) }
sub attributes   { ATTRIBUTES   }
sub request_type { REQUEST_TYPE }
sub url          { URL          }
sub is_ready     { READY        }

1;

__END__

