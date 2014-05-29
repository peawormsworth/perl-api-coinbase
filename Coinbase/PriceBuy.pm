package Coinbase::PricesBuy;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/prices/buy';
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub request_type { REQUEST_TYPE }
sub url          { URL          }
sub is_ready     { READY        }

1;

__END__

