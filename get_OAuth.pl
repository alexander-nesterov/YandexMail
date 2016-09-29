#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;
use Getopt::Long;
use JSON qw(decode_json);

#./get_ListMail.pl --domain your_domain --login your_login --pddtoken your_token

my $domain = "";
my $login = "";
my $pddtoken = "";
my $API_URL = "https://pddimp.yandex.ru/api2/admin/email/get_oauth_token";

&Main();

sub Main
{
    system("clear");
    GetOptions ("domain=s" => \$domain, "login=s" => \$login, "pddtoken=s" => \$pddtoken) or die("Error in command line arguments\n");
    my $token = &GetPddToken();
    print "https://passport.yandex.ru/passport?mode=oauth&access_token=$token&type=trusted-pdd-partner\r\n";
}

sub GetPddToken
{
    my $ua = LWP::UserAgent->new;

    my $response = $ua->post($API_URL, ["domain" => $domain, "login" => $login], "PddToken" => $pddtoken);

    if ($response->is_success)
    {
	my $decoded = decode_json($response->decoded_content);
	return $decoded->{"oauth-token"};
    }
    else
    {
	return $response->status_line;
    }
}
