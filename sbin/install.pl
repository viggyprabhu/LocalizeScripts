#!/usr/bin/perl
use strict;
use warnings;

use ConfigHelper;
my $conf = &readConfiguration();
my $sbinDir = &getSbinDir();
&runSQLScripts($conf,$sbinDir);

sub runSQLScripts()
{
	my $settings = shift;
	my $sbin = shift;
	my $user = $settings->{'username'};
	my $pass = $settings->{'password'};
	my $database= $settings->{'database'};
	my $server = $settings->{'server'};
	my $port = $settings->{'port'};
	my $sqlFile = $sbin."/database.sql";
	`mysql -u $user -p$pass -h $server -P $port $database < $sqlFile`
}
