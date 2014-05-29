package Coinbase::ButtonCreate;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/buttons/%s/create_order';
use constant ATTRIBUTES   => qw(code);

sub code       { my $self = shift; $self->get_set(@_) }
sub attributes { ATTRIBUTES               }
sub url        { sprintf URL, shift->code }
sub is_ready   { defined shift->code      }

1;

__END__

