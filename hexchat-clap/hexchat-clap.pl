#   hexchat-clap.pl
#   Emphasizes👏your👏point👏.
#   Author: William Woodruff
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

use strict;
use warnings;
use utf8;

use Xchat qw(:all);

my $PLUGIN_NAME = 'clap';
my $PLUGIN_VERS = '1.0';
my $PLUGIN_DESC = 'emphasizes👏your👏point👏';

register($PLUGIN_NAME, $PLUGIN_VERS, $PLUGIN_DESC, \&on_unload);
Xchat::printf("Loaded %s version %s", $PLUGIN_NAME, $PLUGIN_VERS);

sub on_unload {
    Xchat::printf("%s version %s unloaded.", $PLUGIN_NAME, $PLUGIN_VERS);
}

hook_command('clap', \&clap, {help_text => "Usage: /clap <text> to emphasize👏your👏point👏."});

sub clap {
    my $text = $_[1][1];

    if (defined $text) {
        $text =~ s/\s+/👏/g;
        command("say $text");
    }

    return EAT_ALL;
}
