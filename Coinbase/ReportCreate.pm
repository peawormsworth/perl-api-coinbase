package Coinbase::ReportCreate;
use base qw(Coinbase::Request);
use strict;

use constant URL          => 'https://coinbase.com/api/v1/reports';
use constant ATTRIBUTES   => qw(account_id type email callback_url time_range time_range_start time_range_end start_type next_run_date next_run_time repeat times);
use constant REQUEST_TYPE => 'POST';
use constant READY        => 1;

sub account_id       { my $self = shift; $self->get_set(@_) }
sub type             { my $self = shift; $self->get_set(@_) }
sub email            { my $self = shift; $self->get_set(@_) }
sub callback_url     { my $self = shift; $self->get_set(@_) }
sub time_range       { my $self = shift; $self->get_set(@_) }
sub time_range_start { my $self = shift; $self->get_set(@_) }
sub time_range_end   { my $self = shift; $self->get_set(@_) }
sub start_type       { my $self = shift; $self->get_set(@_) }
sub next_run_date    { my $self = shift; $self->get_set(@_) }
sub next_run_time    { my $self = shift; $self->get_set(@_) }
sub repeat           { my $self = shift; $self->get_set(@_) }
sub times            { my $self = shift; $self->get_set(@_) }
sub attributes   { ATTRIBUTES   }
sub request_type { REQUEST_TYPE }
sub url          { URL          }
sub is_ready     {
    my $self = shift;
    return defined $self->type and defined $self->email;
}

1;

__END__

