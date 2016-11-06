#	hexchat-fullwidth.pl
#	Converts ASCII text characters to their UTF-8 fullwidth equivalents.
#	Author: William Woodruff
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

use Xchat qw(:all);

my $PLUGIN_NAME = 'fullwidth';
my $PLUGIN_VERS = '1.0';
my $PLUGIN_DESC = 'fullwidths your text';

register($PLUGIN_NAME, $PLUGIN_VERS, $PLUGIN_DESC, \&on_unload);
Xchat::printf("Loaded %s version %s", $PLUGIN_NAME, $PLUGIN_VERS);

sub on_unload {
	Xchat::printf("%s version %s unloaded.", $PLUGIN_NAME, $PLUGIN_VERS);
}

hook_command('fw', \&fullwidth, {help_text => "Usage: /fw <text> to fullwidth the given text."});

sub fullwidth {
	my $text = $_[1][1];

	if (defined $text) {
		my @chars = split //, $text;

		@chars = map {
			if (ord($_) > 32 && ord($_) < 127) {
				chr(ord($_) + 65248)
			}
			elsif (ord($_) == 32) {
				"\x{3000}"
			}
			else {
				$_
			}
		} @chars;

		# hexchat screws up the last char without a trailing ideographic space
		$text = (join '', @chars) . "\x{3000}";
		command("say $text");
	}

	return EAT_ALL;
}
