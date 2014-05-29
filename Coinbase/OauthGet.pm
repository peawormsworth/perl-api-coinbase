package Coinbase::OauthGet;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/oauth/applications/%s';
use constant REQUEST_TYPE => 'GET';

sub init {
    my $self = shift;
    my %args = @_;
    $self->oauth_id($args{oauth_id}) if exists $args{oauth_id};
    return $self->SUPER::init(@_);
}
sub oauth_id     { my $self = shift; $self->get_set(@_) }
sub request_type { REQUEST_TYPE }
sub is_ready     { defined shift->oauth_id }
sub url          { sprintf URL, shift->oauth_id }

1;

__END__

