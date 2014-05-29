package Coinbase::AccountNew;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/accounts';
use constant ATTRIBUTES   => qw(account);

sub account    { my $self = shift; $self->get_set(@_) }
sub attributes { ATTRIBUTES }
sub url        { URL        }
sub is_ready   {
    my $self = shift;
    return defined $self->account
       and ref $self->account eq 'HASH'
       and exists $self->account->{name};
}

1;

__END__

