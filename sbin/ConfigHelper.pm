use File::Spec;
use File::Basename;
use YAML::XS qw(LoadFile);

my $sbinDir = dirname(File::Spec->rel2abs( __FILE__ ));
my $conf = "$sbinDir"."/../config/config.yaml";
my $tmpDir = "$sbinDir"."/../tmp/";
my $settings = LoadFile($conf);
sub readConfiguration()
{
	return $settings;
}

sub getSbinDir()
{
	return $sbinDir;
}

sub saveNonLocalizedStrings()
{
	my $arr = shift;
	my $tmpStoreFile = "$tmpDir/unlocalized.txt";
	open FILE,"+>>$tmpStoreFile";
	foreach my $str (@$arr)
	{
		print FILE $str."\n";
	}	
	close FILE;
}

1;
