use DBI;
use ConfigHelper;

my $table = "strings";
my $stringColumn = 'string';
my $dbh;
sub addStrings()
{
	my $stringToBeAdded = shift;
	my $localizedToBeAdded = shift;
	my $fileName = shift;
	my $stmt;
	my $row = &checkIfEntryPresent($stringToBeAdded);
	while($row)
	{
		my $rowId = $row->{id};
		my $unlocalizedFiles=$row->{unlocalizedFiles};
		my $localizedFiles=$row->{localizedFiles};
		if($localizedToBeAdded=~m/^$/)
		{
			my $newUnlocalizedFiles = &appendToFiles($unlocalizedFiles,$fileName);
			$stmt = qq|Update $table set unlocalizedFiles="$newUnlocalizedFiles" where id='$rowId';|;
		}
		else
		{
			my $localized=$row->{localized};
			if($localized=~m/^$/)
			{
				$stmt = qq|Update $table set localizedFiles='$fileName' AND localized="$localizedToBeAdded" where id='$rowId';|;
			}
			else
			{
				my $newlocalizedFiles = &appendToFiles($localizedFiles,$fileName);
				
				$stmt = qq|Update $table set localizedFiles='$newlocalizedFiles' where id='$rowId';|;

			}
		}
		$dbh->do($stmt);
		return;
	}
	if($localizedToBeAdded=~m/^$/)
	{
		$stmt = qq|insert into $table (string,unlocalizedFiles) values ("$stringToBeAdded",'$fileName');|;		
	}
	else
	{
		$stmt = qq|insert into $table (string,localized,localizedFiles) values ("$stringToBeAdded","$localizedToBeAdded",'$fileName');|;		

	}
	$dbh->do($stmt);
	
}

sub checkIfEntryPresent()
{
	my $msgid = shift;
	my $stmt = qq|Select * from strings where string="$msgid"|;
	$sth = $dbh->prepare($stmt);
	$sth->execute();
	$result = $sth->fetchrow_hashref();
	$sth->finish();
	#print "String returned: $result->{string}\n";
	#print "localized returned: $result->{localized}\n";
	#print "file returned: $result->{file}\n";
	return $result;
		
}

sub getNonLocalizedStrings()
{
	my @strings;
	my $str;
	my $stmt = qq|Select string from strings where localized is null|;
	$sth = $dbh->prepare($stmt);
	$sth->execute();
	$sth->bind_columns(\$str);
	while($sth->fetch())
	{
		print $str;
		push(@strings,$str);
	}
	$sth->finish();
	return \@strings;
}

sub appendToFiles()
{
	my $existing = shift;
	my $fileName = shift;
	#my $quoted = quotemeta($fileName);	
	if($existing=~m/^$/)
	{
		return $fileName;
	}
	elsif(index($existing, $fileName) != -1)
	{
#		print "Quoted:".$quoted." Existing:".$existing;
		return $existing;
	}
	else
	{
		return $existing.",".$fileName;
	}
}

sub initializeDatabaseConnection()
{
	my $conf = &readConfiguration();
	my $database = $conf->{'database'};
	my $username = $conf->{'username'};
	my $password = $conf->{'password'};
	my $host = $conf->{'server'};
	my $port = $conf->{'port'};
	$dbh = DBI->connect("DBI:mysql:$database;host=$host;port=$port", $username, $password ) || die "";

}

sub tearDownDatabaseConnection()
{
	$dbh->disconnect();
}

1;
