package Coinbase::AccountSetPrimary;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/accounts/%s/primary';
use constant REQUEST_TYPE => 'POST';

sub init {
    my $self = shift;
    my %args = @_;
    $self->id($args{id}) if exists $args{id};
    return $self->SUPER::init(@_);
}
sub id           { my $self = shift; $self->get_set(@_) }
sub url          { sprintf URL, shift->id }
sub request_type { REQUEST_TYPE           }
sub is_ready     { defined shift->id      }

1;

__END__

