package Coinbase::Processor;
use strict;

use base qw(Coinbase::DefaultPackage);

use constant DEBUG => 0;

# you can use a lower version, but then you are responsible for SSL cert verification code...
use LWP::UserAgent 6;
use URI;
use CGI;
use JSON;
use MIME::Base64;
use Time::HiRes qw(gettimeofday);
use Digest::SHA qw(hmac_sha256_hex);
use Math::BigFloat;
use Data::Dumper;

# Account...
use Coinbase::AccountChanges;
## Accounts...
use Coinbase::AccountGet;
use Coinbase::AccountBalance;
#use Coinbase::AccountNew;
#use Coinbase::AccountUpdate;
#use Coinbase::AccountSetPrimary;
#use Coinbase::AccountDelete;
## BTC Addresses...
use Coinbase::Addresses;
## Oauth Applications..
use Coinbase::OauthList;
use Coinbase::OauthGet;
use Coinbase::OauthNew;
## Authorization...
use Coinbase::AuthInfo;
## Buttons...
use Coinbase::ButtonNew;
use Coinbase::ButtonCreate;
## Buy...
use Coinbase::Buy;
## Contacts...
use Coinbase::ContactEmails;
## Currencies...
use Coinbase::CurrencyInfo;
use Coinbase::CurrencyRates;
## Orders
use Coinbase::OrderList;
use Coinbase::OrderNew;
use Coinbase::OrderGet;
## Payment Methods...
use Coinbase::PaymentMethods;
## Prices...
#use Coinbase::PriceBuy;
#use Coinbase::PriceSell;
#use Coinbase::PriceSpot;
#use Coinbase::PriceHistory;
## Recurring Payments
#use Coinbase::RecurringList;
#use Coinbase::RecurringGet;
## Reports...
#use Coinbase::ReportList;
#use Coinbase::ReportCreate;
#use Coinbase::ReportGet;
## Sells...
##use Coinbase::Sell;
## Subscribers...
#use Coinbase::SubscriberList;
#use Coinbase::SubscriberGet;
## Tokens...
#use Coinbase::TokenNew;
#use Coinbase::TokenRedeem;
## Transactions...
#use Coinbase::TransactionList;
#use Coinbase::TransactionGet;
#use Coinbase::TransactionSend;
#use Coinbase::TransactionRequest;
#use Coinbase::TransactionRequestRepeat;
#use Coinbase::TransactionRequestCancel;
##use Coinbase::TransactionRequestComplete;
#use Coinbase::TransactionRequestPay; # I named this 'pay' but im not sure if that is what the request does.
## Transfers...
#use Coinbase::TransferList;
## Users...
#use Coinbase::UserNew;
#use Coinbase::UserGet;
#use Coinbase::UserUpdate;

use constant COMPANY          => 'Coinbase';
use constant ATTRIBUTES       => qw(key secret);
use constant ERROR_NO_REQUEST => 'No request object to send';
use constant ERROR_NOT_READY  => 'Not enough information to send a %s request';
use constant ERROR_READY      => 'The request IS%s READY to send';
use constant ERROR_COINBASE   => COMPANY . ' error: "%s"';
use constant ERROR_UNKNOWN    => COMPANY . ' returned an unknown status';

use constant CLASS_ACTION_MAP => {
    # Account...
    account_changes     => 'Coinbase::AccountChanges',
    # Accounts...
    account_get         => 'Coinbase::AccountGet',
    account_balance     => 'Coinbase::AccountBalance',
    account_new         => 'Coinbase::AccountNew',
    account_update      => 'Coinbase::AccountUpdate',
    account_set_primary => 'Coinbase::AccountSetPrimary',
    account_delete      => 'Coinbase::AccountDelete',
    # BTC Addresses...
    addresses           => 'Coinbase::Addresses',
    # Oauth Applications..
    oauth_list          => 'Coinbase::OauthList',
    oauth_get           => 'Coinbase::OauthGet',
    oauth_new           => 'Coinbase::OauthNew',
    # Authorization...
    auth_info           => 'Coinbase::AuthInfo',
    # Buttons...
    button_new          => 'Coinbase::ButtonNew',
    button_create       => 'Coinbase::ButtonCreate',
    # Buy...
    buy                 => 'Coinbase::Buy',
    # Contacts...',
    contact_emails      => 'Coinbase::ContactEmails',
    # Currencies...
    currency_info       => 'Coinbase::CurrencyInfo',
    currency_rates      => 'Coinbase::CurrencyRates',
    # Orders
    order_list          => 'Coinbase::OrderList',
    order_new           => 'Coinbase::OrderNew',
    order_get           => 'Coinbase::OrderGet',
    # Payment Methods...
    payment_methods     => 'Coinbase::PaymentMethods',
    # Prices...
    price_buy           => 'Coinbase::PriceBuy',
    price_sell          => 'Coinbase::PriceSell',
    price_spot          => 'Coinbase::PriceSpot',
    price_history       => 'Coinbase::PriceHistory',
    # Recurring Payments
    recurring_list      => 'Coinbase::RecurringList',
    recurring_get       => 'Coinbase::RecurringGet',
    # Reports...
    report_list         => 'Coinbase::ReportList',
    report_create       => 'Coinbase::ReportCreate',
    report_get          => 'Coinbase::ReportGet',
    # Sells...
    sell                => 'Coinbase::Sell',
    # Subscribers...
    subscriber_list     => 'Coinbase::SubscriberList',
    subscriber_get      => 'Coinbase::SubscriberGet',
    # Tokens...
    token_new           => 'Coinbase::TokenNew',
    token_redeem        => 'Coinbase::TokenRedeem',
    # Transactions...
    transaction_list    => 'Coinbase::TransactionList',
    transaction_get     => 'Coinbase::TransactionGet',
    transaction_send    => 'Coinbase::TransactionSend',
    transaction_request => 'Coinbase::TransactionRequest',
    transaction_repeat  => 'Coinbase::TransactionRequestRepeat',
    transaction_cancel  => 'Coinbase::TransactionRequestCancel',
    transaction_pay     => 'Coinbase::TransactionRequestPay ',
    # Transfers...
    transfer_list       => 'Coinbase::TransferList',
    # Users...
    user_new            => 'Coinbase::UserNew',
    user_get            => 'Coinbase::UserGet',
    user_update         => 'Coinbase::UserUpdate',
};

sub is_ready {
    my $self = shift;
    my $ready = 0;
    # here we are checking whether or not to default to '0' (not ready to send) based on this objects settings.
    # the settings in here are the token and the secret provided to you by Coinbase.
    # if we dont have to add a nonce, then also set to '1'
    if (not $self->request->is_private or (defined $self->secret and defined $self->key)) {
       $ready = $self->request->is_ready;
    }
    warn sprintf(ERROR_READY, $ready ? '' : ' NOT') . "\n" if DEBUG;

    return $ready;
}

sub send {
    my $self = shift;

    # clear any previous response values... because if you wan it, you shoulda put a variable on it.
    $self->response(undef);
    $self->error(undef);

    unless ($self->request) {
        $self->error({
            type    => __PACKAGE__,
            message => ERROR_NO_REQUEST,
        });
    }
    else {
        # validate that the minimum required request attributes are set here.
        if (not $self->is_ready) {
             $self->error({
                 type    => __PACKAGE__,
                 message => sprintf(ERROR_NOT_READY, ref $self->request),
             });
        }
        else {
            # make sure we have an request to send...
            my $request = $self->http_request(HTTP::Request->new);
            $request->method($self->request->request_type);
            $request->uri($self->request->url);
            #my %query_form = $self->request->request_content;
            my $uri = URI->new;
            $uri->query_form($self->request->request_content);
            if ($self->request->request_type eq 'POST') {
                $request->content($uri->query);
                $request->content_type($self->request->content_type);
            }
            elsif ($self->request->request_type eq 'GET' and $uri->query) {
                $request->uri($request->uri . '?' . $uri->query);
            }
            if ($self->request->is_private) {
                $request->header(ACCESS_KEY       => $self->key      );
                $request->header(ACCESS_SIGNATURE => $self->signature);
                $request->header(ACCESS_NONCE     => $self->nonce    );
            }
   
            #$request->header('Accept'   => 'application/json');

            # create a new user_agent each time...
            $self->user_agent(LWP::UserAgent->new);
            $self->user_agent->agent('Perl Coinbase::API');
            $self->user_agent->ssl_opts(verify_hostname => 1);

            warn Data::Dumper->Dump([$self->user_agent, $request],[qw(UserAgent Request)]) if DEBUG;

            $self->http_response($self->user_agent->request($request));
            $self->process_response;
        }
    }
    return $self->is_success;
}

sub process_response {
    my $self = shift;

    warn sprintf "Response CODE: %s\n", $self->http_response->code    if DEBUG;
    warn sprintf "Content: %s\n",       $self->http_response->content if DEBUG;

    my $content;
    my $error_msg;
    eval {
        warn Data::Dumper->Dump([$self->http_response],['Response'])  if DEBUG;
        # hmm... I dont know what is going on here. Originally I saw a response as a simple string
        # so I put this fix in place. But now I am not getting the error... so I commented it out.
        # Leave this here for now... if there is future problems with AuthInfo... we can uncomment this...
        #
        # This is a hack! Because Coinbase forgot to return a proper json object for...
        #if ($self->request->isa('Coinbase::AuthInfo') and length($self->http_response->content)) {
            #$content = $self->http_response->content;
        #}
        #else {
            $content = $self->json->decode($self->http_response->content);
        #}
        1;
    } or do {
        $self->error("Network Request (REST/JSON) error: $@");
        warn $self->error . "\n";
        warn sprintf "Content was: %s\n", $self->http_response->content;
    };

    unless ($self->error) {
        if (ref $content eq 'HASH' and exists $content->{error}) {
            warn sprintf(ERROR_COINBASE, $content->{error}) . "\n";
            $self->error($content->{error});
        }
        else {
            $self->response($content);
        }
    }

    return $self->is_success;
}

# signature : is a SHA256 HMAC encoded message using your secret key and
# input of the nonce, client ID and API key.
# It is converted to Uppercase Hex.
sub signature {
    my $self = shift;
    return hmac_sha256_hex($self->nonce . $self->http_request->uri->as_string . $self->http_request->content || '', $self->secret);
}

# careful, this is "hot". It will return a different value with each call.
# perhaps this should be a constant class object in the Requests object.
# Since a new one is created with each processor action call.
sub nonce     { shift->request->nonce       }
sub json      { shift->{json} ||= JSON->new }
sub is_success{ defined shift->response     }
sub attributes{ ATTRIBUTES                  }

# this method makes the action call routines simpler...
sub _class_action {
    my $self = shift;
    my $class = CLASS_ACTION_MAP->{((caller(1))[3] =~ /::(\w+)$/)[0]};
    $self->request($class->new(@_));
    return $self->send ? $self->response : undef;
}

sub account_changes     { _class_action(@_) }
sub account_get         { _class_action(@_) }
sub account_balance     { _class_action(@_) }
sub account_new         { _class_action(@_) }
sub account_update      { _class_action(@_) }
sub account_set_primary { _class_action(@_) }
sub account_delete      { _class_action(@_) }
sub addresses           { _class_action(@_) }
sub oauth_list          { _class_action(@_) }
sub oauth_get           { _class_action(@_) }
sub oauth_new           { _class_action(@_) }
sub auth_info           { _class_action(@_) }
sub button_new          { _class_action(@_) }
sub button_create       { _class_action(@_) }
sub buy                 { _class_action(@_) }
sub contact_emails      { _class_action(@_) }
sub currency_info       { _class_action(@_) }
sub currency_rates      { _class_action(@_) }
sub order_list          { _class_action(@_) }
sub order_new           { _class_action(@_) }
sub order_get           { _class_action(@_) }
sub payment_methods     { _class_action(@_) }
sub price_buy           { _class_action(@_) }
sub price_sell          { _class_action(@_) }
sub price_spot          { _class_action(@_) }
sub price_history       { _class_action(@_) }
sub recurring_list      { _class_action(@_) }
sub recurring_get       { _class_action(@_) }
sub report_list         { _class_action(@_) }
sub report_create       { _class_action(@_) }
sub report_get          { _class_action(@_) }
sub sell                { _class_action(@_) }
sub subscriber_list     { _class_action(@_) }
sub subscriber_get      { _class_action(@_) }
sub token_new           { _class_action(@_) }
sub token_redeem        { _class_action(@_) }
sub transaction_list    { _class_action(@_) }
sub transaction_get     { _class_action(@_) }
sub transaction_send    { _class_action(@_) }
sub transaction_request { _class_action(@_) }
sub transaction_repeat  { _class_action(@_) }
sub transaction_cancel  { _class_action(@_) }
sub transaction_pay     { _class_action(@_) }
sub transfer_list       { _class_action(@_) }
sub user_new            { _class_action(@_) }
sub user_get            { _class_action(@_) }
sub user_update         { _class_action(@_) }

sub key           { my $self = shift; $self->get_set(@_) }
sub secret        { my $self = shift; $self->get_set(@_) }
sub error         { my $self = shift; $self->get_set(@_) }
sub http_response { my $self = shift; $self->get_set(@_) }
sub request       { my $self = shift; $self->get_set(@_) }
sub response      { my $self = shift; $self->get_set(@_) }
sub http_request  { my $self = shift; $self->get_set(@_) }
sub user_agent    { my $self = shift; $self->get_set(@_) }
sub status        { my $self = shift; $self->get_set(@_) }

1;

__END__


