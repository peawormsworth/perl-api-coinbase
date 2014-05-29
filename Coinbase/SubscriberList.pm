package Coinbase::SubscriberList;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/subscribers';
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub url          { URL          } 
sub request_type { REQUEST_TYPE }
sub is_ready     { READY        }

1;

__END__

