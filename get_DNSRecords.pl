#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::UserAgent;
use Getopt::Long;
use JSON qw(decode_json);

#./get_DNSRecords.pl --domain your_domain --token your_token

my $domain = '';
my $pddtoken = '';
my $page = 1;
my $on_page = 50;

&Main();

sub Main
{
    system('clear');
    GetOptions ('domain=s' => \$domain, 'token=s' => \$pddtoken) or die("Error in command line arguments\n");
    &PrintDNS();
}

sub SetURL
{
    return "https://pddimp.yandex.ru/api2/admin/dns/list?domain=$domain";
}

sub PrintDNS
{
    my $ua = LWP::UserAgent->new;
    my $url = &SetURL();

    my $response = $ua->get($url, 'PddToken' => $pddtoken);

    if ($response->is_success)
    {
	my $decoded = decode_json($response->decoded_content);
	print 'Domain: ' . $decoded->{'domain'} . "\r\n";
	print 'DNS Records:' . "\r\n";
	my $result = $decoded->{'records'};
	my $i = 1;

	foreach my $record(@{$result})
	{
	    print "$i)====\r\n";
	    print "\ttype: "		. $record->{'type'}		. "\r\n";
	    print "\trecord_id: "	. $record->{'record_id'}	. "\r\n";
	    print "\tdomain: "		. $record->{'domain'}		. "\r\n";
	    print "\tfqdn: "		. $record->{'fqdn'}		. "\r\n";
	    print "\tttl: "		. $record->{'ttl'}		. "\r\n";
	    print "\tsubdomain: "	. $record->{'subdomain'}	. "\r\n";
	    print "\tcontent: "		. $record->{'content'}		. "\r\n";
	    print "\tpriority: "	. $record->{'priority'}		. "\r\n";
	    $i++;
	}
    }
    else
    {
	print $response->status_line;
    }
}

