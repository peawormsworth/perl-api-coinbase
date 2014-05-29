#!/usr/bin/perl -wT

use 5.010;
use warnings;
use strict;
use lib qw(.);

use base qw(Coinbase::DefaultPackage);

use Coinbase::Processor;
use Data::Dumper;
use JSON;

use constant DEBUG => 0;

# Enter your Coinbase API key and secret values here...
use constant KEY       => '';
use constant SECRET    => '';

# Tests...
use constant TEST_ACCOUNT_CHANGES     => 0;
use constant TEST_ACCOUNT_GET         => 0;

# Account Balance is NOT working for me...
use constant TEST_ACCOUNT_BALANCE     => 0;

# These Account operations have never been tested...
use constant TEST_ACCOUNT_NEW         => 0;
use constant TEST_ACCOUNT_UPDATE      => 0;
use constant TEST_ACCOUNT_SET_PRIMARY => 0;
use constant TEST_ACCOUNT_DELETE      => 0;

use constant TEST_ADDRESSES           => 0;
use constant TEST_OAUTH_LIST          => 0;
use constant TEST_OAUTH_GET           => 0;
use constant TEST_OAUTH_NEW           => 0;

use constant TEST_AUTH_INFO           => 0;

use constant TEST_BUTTON_NEW          => 0;
use constant TEST_BUTTON_CREATE       => 0;

use constant TEST_BUY                 => 0;

use constant TEST_CONTACT_EMAILS      => 0;

use constant TEST_CURRENCY_INFO       => 0;
use constant TEST_CURRENCY_RATES      => 0;

use constant TEST_ORDER_LIST          => 0;
use constant TEST_ORDER_NEW           => 1;
use constant TEST_ORDER_GET           => 1;


main->new->go;

sub json        { shift->{json}      ||  JSON->new }
sub processor   { shift->{processor} ||= Coinbase::Processor->new(key => KEY, secret => SECRET) }
sub account_id  { my $self = shift; $self->get_set(@_) }
sub order_id    { my $self = shift; $self->get_set(@_) }
sub button_code { my $self = shift; $self->get_set(@_) }

sub go  {
    my $self = shift;

    say "\n* turn on DEBUG to see response content\n" unless DEBUG;

    say '=== Begin tests';

    if (TEST_ACCOUNT_CHANGES) {
        print 'Account Changes... ';
        my $account = $self->processor->account_changes;
        if ($account) {
            say 'success';
            say Dumper $account if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }


    if (TEST_ACCOUNT_GET) {
        print 'Account Get... ';
        my $account = $self->processor->account_get;
        if ($account) {
            say 'success';
            say Dumper $account if DEBUG;
            $self->account_id($account->{accounts}->[0]->{id});
            #printf "ACCOUNT ID: %s\n", $self->account_id;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ACCOUNT_BALANCE and TEST_ACCOUNT_CHANGES) {
        printf 'Account Balance [%s]... ', $self->account_id;
        my $account = $self->processor->account_balance(account_id => $self->account_id);
        if ($account) {
            say 'success';
            say Dumper $account if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ADDRESSES) {
        print 'Addresses... ';
        my $addresses = $self->processor->addresses;
        if ($addresses) {
            say 'success';
            say Dumper $addresses if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_OAUTH_LIST) {
        print 'Oauth Applications List... ';
        my $list = $self->processor->oauth_list;
        if ($list) {
            say 'success';
            say Dumper $list if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_OAUTH_GET) {
        print 'Oauth Applications List... ';
        my $oauth = $self->processor->oauth_get(oauth_id => 1);
        if ($oauth) {
            say 'success';
            say Dumper $oauth if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_OAUTH_NEW) {
        print 'New Oauth Application... ';
        my $oauth = $self->processor->oauth_new(application => {name => 'Testing', redirect_uri => 'http://exmple.com'});
        if ($oauth) {
            say 'success';
            say Dumper $oauth if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_AUTH_INFO) {
        print 'New Oauth Application... ';
        my $auth = $self->processor->auth_info;
        if ($auth) {
            say 'success';
            say Dumper $auth if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_BUTTON_NEW) {
        print 'New Button... ';
        my $button = $self->processor->button_new(button => {name => 'test', price_string => '1.23', price_currency_iso => 'USD'});
        if ($button) {
            $self->button_code($button->{button}->{code});
            say 'success';
            say Dumper $button if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_BUTTON_CREATE and TEST_BUTTON_NEW) {
        print 'Make a Button... ';
        my $button = $self->processor->button_create(code => $self->button_code);
        if ($button) {
            say 'success';
            say Dumper $button if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_BUY) {
        print 'Make a Buy... ';
        my $buy = $self->processor->buy(qty => '0.000001');
        if ($buy) {
            say 'success';
            say Dumper $buy if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_CONTACT_EMAILS) {
        print 'Contact Emails... ';
        my $emails = $self->processor->contact_emails;
        if ($emails) {
            say 'success';
            say Dumper $emails if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_CURRENCY_INFO) {
        print 'Currency Information... ';
        my $currency_info = $self->processor->currency_info;
        if ($currency_info) {
            say 'success';
            say Dumper $currency_info if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_CURRENCY_RATES) {
        print 'Currency Exchange Rates... ';
        my $currency_rates = $self->processor->currency_rates;
        if ($currency_rates) {
            say 'success';
            say Dumper $currency_rates if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ORDER_LIST) {
        print 'Orders Received... ';
        my $orders = $self->processor->order_list;
        if ($orders) {
            say 'success';
            say Dumper $orders if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ORDER_NEW) {
        print 'Create a New Order... ';
        my $order = $self->processor->order_new(button => {name => 'test', price_string => '1.23', price_currency_iso => 'USD'});
        if ($order) {
            say 'success';
            say Dumper $order if DEBUG;
            $self->order_id($order->{order}->{id});
            #printf "I found ORDER ID: %s\n", $self->order_id;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ORDER_GET and TEST_ORDER_NEW) {
        print 'Get an Order... ';
        my $button = $self->processor->order_get(id => $self->order_id);
        if ($button) {
            say 'success';
            say Dumper $button if DEBUG;
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

