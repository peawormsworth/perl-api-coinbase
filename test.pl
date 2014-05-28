#!/usr/bin/perl -wT

use 5.010;
use warnings;
use strict;
use lib qw(.);

use Coinbase::Processor;
use Data::Dumper;
use JSON;

use constant DEBUG => 0;

# Enter your Coinbase API key and secret values here...
use constant KEY       => '';
use constant SECRET    => '';

# Tests...
use constant TEST_ACCOUNT_CHANGES    => 1;


main->new->go;

sub new       { bless {} => shift }
sub json      { shift->{json}      ||  JSON->new }
sub processor { shift->{processor} ||= Coinbase::Processor->new(key => KEY, secret => SECRET) }

sub go  {
    my $self = shift;

    say '=== Begin tests';
    if (TEST_ACCOUNT_CHANGES) {
        my $account = $self->processor->account_changes;
        print 'Ticker...';
        if ($account) {
            say 'success';
            say Dumper $account if DEBUG;
            say Dumper $account;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    say '=== Done tests';
}

1;

__END__

