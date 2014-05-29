package Coinbase::AccountBalance;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/accounts/%s/balance';
use constant REQUEST_TYPE => 'GET';

sub init {
    my $self = shift;
    my %args = @_;
    $self->account_id($args{account_id}) if exists $args{account_id};
    return $self->SUPER::init(@_);
}
sub account_id   { my $self = shift; $self->get_set(@_) }
sub request_type { REQUEST_TYPE }
sub is_ready     { defined shift->account_id }
sub url          { sprintf URL, shift->account_id }

1;

__END__

