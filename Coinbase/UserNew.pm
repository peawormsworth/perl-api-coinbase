package Coinbase::UserNew;
use base qw(Coinbase::Request);
use strict;

use constant URL        => 'https://coinbase.com/api/v1/users';
use constant ATTRIBUTES => qw(user client_id scopes);
use constant READY      => 1;

sub user       { my $self = shift; $self->get_set(@_) }
sub client_id  { my $self = shift; $self->get_set(@_) }
sub scopes     { my $self = shift; $self->get_set(@_) }
sub attributes { ATTRIBUTES }
sub url        { URL        }
sub is_ready   {
    my $self = shift;
    return defined $self->user
       and     ref $self->user eq 'HASH'
       and  exists $self->user->{email}
       and defined $self->user->{email};
}

1;

__END__

