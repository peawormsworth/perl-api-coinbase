package Coinbase::Buy;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/buys';
use constant ATTRIBUTES   => qw(account_id qty agree_btc_amount_varies payment_method_id);

sub account_id              { my $self = shift; $self->get_set(@_) }
sub qty                     { my $self = shift; $self->get_set(@_) }
sub agree_btc_amount_varies { my $self = shift; $self->get_set(@_) }
sub payment_method_id       { my $self = shift; $self->get_set(@_) }
sub attributes              { ATTRIBUTES         }
sub url                     { URL                }
sub is_ready                { defined shift->qty }

1;

__END__

