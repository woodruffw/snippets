#	hexchat-spacing.pl
#	Spaces your text.
#	Author: William Woodruff
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

use Xchat qw(:all);

my $PLUGIN_NAME = 'spacing';
my $PLUGIN_VERS = '1.0';
my $PLUGIN_DESC = 'spaces your text';

register($PLUGIN_NAME, $PLUGIN_VERS, $PLUGIN_DESC, \&on_unload);
Xchat::printf("Loaded %s version %s", $PLUGIN_NAME, $PLUGIN_VERS);

sub on_unload {
	Xchat::printf("%s version %s unloaded.", $PLUGIN_NAME, $PLUGIN_VERS);
}

hook_command('sp', \&space, {help_text => "Usage: /sp <text> to space the given text."});

sub space {
	my $text = $_[1][1];

	if (defined $text) {
		my @chars = split //, $text;
		@chars = map { $_ . ' ' } @chars;
		$text = join '', @chars;
		command("say $text");
	}

	return EAT_ALL;
}
