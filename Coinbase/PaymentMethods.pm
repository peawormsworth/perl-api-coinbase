package Coinbase::PaymentMethods;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/payment_methods';
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub request_type { REQUEST_TYPE }
sub url          { URL          }
sub is_ready     { READY        }

1;

__END__

