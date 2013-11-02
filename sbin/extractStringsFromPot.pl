#!/usr/bin/perl
use strict;
use warnings;
use MysqlHelper;
use ConfigHelper;

initializeDatabaseConnection();
my $conf = &readConfiguration();
my $potFileDir = $conf->{'poFilesDir'};

my $files = &getAllPotFiles($potFileDir);
#foreach my $potFile (@$files)
#{
#	my $potFilePath = "$potFileDir/$potFile";
#	print "Reading $potFilePath\n";
#	open(POT_FILE,$potFilePath);
#	my @msgIdLines;
#
#	while(my $currentLine = <POT_FILE>)
#	{
#		chomp($currentLine);
#		if($currentLine=~/^msgid "(.+)"$/)
#		{
#			my $msgid = $1;
#			my $msgstr = "";
#			my $nextLine = <POT_FILE>;
#			if($nextLine=~/^msgstr "(.+)"$/)
#			{
#				$msgstr = $1;	
#			}
#			&addStrings($msgid,$msgstr,$potFile);
#		}
#	}
#	close(POT_FILE);
#}
&createNonLocalizedStringsFile();	
&tearDownDatabaseConnection();
sub getAllPotFiles()
{
	my $dir = shift;
	opendir DIR, $dir;
	my @files = grep { $_ ne '.' && $_ ne '..' } readdir DIR;
	my @potFiles;
	foreach my $file (@files)
	{
		if($file=~m/\.po$/)
		{
			push(@potFiles,$file);
		}
	}
	closedir DIR;
	return \@potFiles;

}

sub createNonLocalizedStringsFile()
{
	my $nonLocalized = &getNonLocalizedStrings();
	&saveNonLocalizedStrings($nonLocalized);
}

