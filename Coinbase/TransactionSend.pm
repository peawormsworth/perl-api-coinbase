package Coinbase::TransactionSend;
use base qw(Coinbase::Request);
use strict;

use constant URL        => 'https://coinbase.com/api/v1/transactions/send_money';
use constant ATTRIBUTES => qw(account_id transaction);

sub token_id   { my $self = shift; $self->get_set(@_) }
sub attributes { ATTRIBUTES }
sub url        { URL }
sub is_ready   {
    my $self = shift;
    return defined $self->transaction
       and     ref $self->transaction eq 'HASH'
       and  exists $self->transaction->{to};
}

1;

__END__

