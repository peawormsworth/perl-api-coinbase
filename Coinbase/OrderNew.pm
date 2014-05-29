package Coinbase::OrderNew;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/orders';
use constant ATTRIBUTES   => qw(account_id button);
use constant READY        => 1;

sub account_id   { my $self = shift; $self->get_set(@_) }
sub button       { my $self = shift; $self->get_set(@_) }
sub attributes   { ATTRIBUTES }
sub url          { URL        }
sub is_ready     {
    my $self = shift;
    return defined $self->button
       and ref     $self->button eq 'HASH'
       and exists  $self->button->{name}
       and exists  $self->button->{price_string}
       and exists  $self->button->{price_currency_iso}
}

1;

__END__

