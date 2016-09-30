#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;
use Getopt::Long;
use JSON qw(decode_json);

#./get_ListMail.pl --domain your_domain --token your_token

my $domain = '';
my $pddtoken = '';
my $page = 1;
my $on_page = 50;

&Main();

sub Main
{
    system("clear");
    GetOptions ('domain=s' => \$domain, 'token=s' => \$pddtoken) or die("Error in command line arguments\n");
    &PrintAllEmail();
}

sub SetURL
{
    return "https://pddimp.yandex.ru/api2/admin/email/list?domain=$domain&page=$page&on_page=$on_page";
}

sub PrintAllEmail
{
    my $ua = LWP::UserAgent->new;
    my $url = &SetURL();

    my $response = $ua->get($url, 'PddToken' => $pddtoken);

    if ($response->is_success)
    {
	my $decoded = decode_json($response->decoded_content);
	print 'Domain: ' . $decoded->{"domain"} . "\r\n";
	print 'Logins:' . "\r\n";
	my $result = $decoded->{'accounts'};
	my $i = 1;

	foreach my $login(@{$result})
	{
	    print "$i) " . $login->{'login'} . "\r\n";
	    $i++;
	}
    }
    else
    {
	print $response->status_line;
    }
}

