#	hexchat-ezfmt.pl
#	Basic text formatting for Hexchat.
#	*italics*, _underline_, and +bold+ supported.
#	Use \ to escape a formatting character.
#	Author: William Woodruff
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

use Xchat qw(:all);

my $PLUGIN_NAME = 'ezfmt';
my $PLUGIN_VERS = '1.0';
my $PLUGIN_DESC = 'basic text formatting';

register($PLUGIN_NAME, $PLUGIN_VERS, $PLUGIN_DESC, \&on_unload);
Xchat::printf("Loaded %s version %s", $PLUGIN_NAME, $PLUGIN_VERS);

sub on_unload {
	Xchat::printf("%s version %s unloaded.", $PLUGIN_NAME, $PLUGIN_VERS);
}

hook_command('fmt', \&fmt, {help_text => "Usage: /fmt <text>"});

sub fmt {
	my %replace_map = (
		'*' => "\x1d",
		'_' => "\x1f",
		'+' => "\x02",
	);

	my $text = $_[1][1];
	my $result = '';

	if (defined $text) {
		for (my $i = 0; $i < length($text); $i++) {
			my $c = substr($text, $i, 1);
			my $e = substr($text, $i - 1, 1) eq '\\';

			if ($c =~ /[*_+]/ && !$e) {
				$result .= $replace_map{$c};
			}
			else {
				$result .= $c if $c ne '\\' || $e;
			}
		}

		command("say $result");
	}

	return EAT_ALL;
}
