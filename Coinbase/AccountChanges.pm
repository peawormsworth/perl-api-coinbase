package Coinbase::AccountChanges;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/account_changes';
use constant REQUEST_TYPE => 'GET';
use constant ATTRIBUTES   => qw(page account_id);
use constant READY        => 1;

sub page         { my $self = shift; $self->get_set(@_) }
sub account_id   { my $self = shift; $self->get_set(@_) }
sub request_type { REQUEST_TYPE }
sub attributes   { ATTRIBUTES   }
sub url          { URL          }
sub is_ready     { READY        }

1;

__END__

