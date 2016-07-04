#	hexchat-america.pl
#	Makes your text patriotic.
#	Author: William Woodruff
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

use Xchat qw(:all);

my $PLUGIN_NAME = 'america';
my $PLUGIN_VERS = '1.0';
my $PLUGIN_DESC = 'makes your text patriotic';

register($PLUGIN_NAME, $PLUGIN_VERS, $PLUGIN_DESC, \&on_unload);
Xchat::printf("Loaded %s version %s", $PLUGIN_NAME, $PLUGIN_VERS);

sub on_unload {
	Xchat::printf("%s version %s unloaded.", $PLUGIN_NAME, $PLUGIN_VERS);
}

hook_command('america', \&america, {help_text => "Usage: /america <text>"});

sub america {
	my @colors = ("\cC4", "\cC0", "\cC2"); # red, white, and blue
	my $text = $_[1][1];
	my $result = '';
	my $i = 0;

	if (defined $text) {
		for (split //, $text) {
			$result .= "$colors[$i]$_";
			$i = ($i + 1) % 3;
		}

		command("say $result");
	}

	return EAT_ALL;
}
