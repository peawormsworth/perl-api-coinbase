package Coinbase::TokenNew;
use base qw(Coinbase::Request);
use strict;

use constant URL   => 'https://coinbase.com/api/v1/tokens';
use constant READY => 1;

sub url      { URL   }
sub is_ready { READY }

1;

__END__

