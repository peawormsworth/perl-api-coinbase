package Coinbase::UserGet;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/users';
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;

sub url          { URL          }
sub is_ready     { READY        }
sub request_type { REQUEST_TYPE }

1;

__END__

