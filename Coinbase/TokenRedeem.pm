package Coinbase::TokenRedeem;
use base qw(Coinbase::Request);
use strict;

use constant URL        => 'https://coinbase.com/api/v1/tokens/redeem';
use constant ATTRIBUTES => qw(token_id);

sub token_id { my $self = shift; $self->get_set(@_) }
sub url      { URL }
sub is_ready { defined shift->token_id }

1;

__END__

