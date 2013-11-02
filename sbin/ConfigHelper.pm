use File::Spec;
use File::Basename;
use YAML::XS qw(LoadFile);

my $sbinDir = dirname(File::Spec->rel2abs( __FILE__ ));
my $conf = "$sbinDir"."/../config/config.yaml";
my $settings = LoadFile($conf);
sub readConfiguration()
{
	return $settings;
}
sub getSbinDir()
{
	return $sbinDir;
}
1;
