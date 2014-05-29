package Coinbase::TransactionRequestComplete;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/transactions/%s/complete_request';
use constant ATTRIBUTES   => qw(account_id);
use constant REQUEST_TYPE => 'PUT';

sub init {
    my $self = shift;
    my %args = @_;
    $self->id($args{id}) if exists $args{id};
    return $self->SUPER::init(@_);
}
sub id           { my $self = shift; $self->get_set(@_) }
sub account_id   { my $self = shift; $self->get_set(@_) }
sub url          { sprintf URL, shift->id }
sub request_type { REQUEST_TYPE           }
sub attributes   { ATTRIBUTES             }
sub is_ready     { defined shift->id      }

1;

__END__

