package Coinbase::AuthInfo;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/authorization';
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub request_type { REQUEST_TYPE }
sub is_ready     { READY        }
sub url          { URL          }

1;

__END__

