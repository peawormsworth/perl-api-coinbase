package Coinbase::ContactEmails;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/contacts';
use constant REQUEST_TYPE => 'GET';
use constant READY        => 1;
use constant ATTRIBUTES   => qw(page limit query);

sub page         { my $self = shift; $self->get_set(@_) }
sub limit        { my $self = shift; $self->get_set(@_) }
sub query        { my $self = shift; $self->get_set(@_) }
sub attributes   { ATTRIBUTES   }
sub request_type { REQUEST_TYPE }
sub url          { URL          }
sub is_ready     { READY        }

1;

__END__

