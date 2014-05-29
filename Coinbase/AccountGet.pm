package Coinbase::AccountGet;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/accounts';
use constant REQUEST_TYPE => 'GET';
use constant ATTRIBUTES   => qw(page limit all_accounts);
use constant READY        => 1;

sub page         { my $self = shift; $self->get_set(@_) }
sub limit        { my $self = shift; $self->get_set(@_) }
sub all_accounts { my $self = shift; $self->get_set(@_) }
sub request_type { REQUEST_TYPE }
sub attributes   { ATTRIBUTES   }
sub url          { URL          }
sub is_ready     { READY        }

1;

__END__

