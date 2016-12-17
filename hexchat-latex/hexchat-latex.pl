#	hexchat-latex.pl
#	Common LaTeX symbol substitution for Hexchat.
#	Allows \mapsto, \implies, etc. to be substituted for Unicode.
#	Author: William Woodruff
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;
use utf8;

use Xchat qw(:all);

my $PLUGIN_NAME = 'latex';
my $PLUGIN_VERS = '1.0';
my $PLUGIN_DESC = 'LaTeX symbol substitution';

register($PLUGIN_NAME, $PLUGIN_VERS, $PLUGIN_DESC, \&on_unload);
Xchat::printf("Loaded %s version %s", $PLUGIN_NAME, $PLUGIN_VERS);

sub on_unload {
	Xchat::printf("%s version %s unloaded.", $PLUGIN_NAME, $PLUGIN_VERS);
}

hook_command('', \&latexify);

sub latexify {
	my %replace_map = (
		'\mapsto' => '↦',
		'\implies' => '→',
		'\forall' => '∀',
		'\exists' => '∃',
		'\not\exists' => '∄',
		'\in' => '∈',
		'\not\in' => '∉',
		'\subset' => '⊂',
		'\superset' => '⊃',
		'\subseteq' => '⊆',
		'\superseteq' => '⊇',
		'\equiv' => '≡',
		'\not\equiv' => '≢',
		'\not=' => '≠',
		'\le' => '≤',
		'\ge' => '≥',
		'\not\le' => '≰',
		'\not\ge' => '≱',
		'\qed' => '∎',
		'\therefore' => '∴',
		'\land' => '∧',
		'\lor' => '∨',
		'\cap' => '∩',
		'\cup' => '∪',
		'\dot' => '∙',
		'\sqrt' => '√',
		'\null' => '∅',
		'\Sum' => '∑',
		'\mathbb{I}' => '𝕀',
		'\mathbb{N}' => 'ℕ',
		'\mathbb{Q}' => 'ℚ',
		'\mathbb{R}' => 'ℝ',
		'\mathbb{Z}' => 'ℤ',
		'\Ell' => 'ℒ',
		'\alpha' => 'α',
		'\beta' => 'β',
		'\Gamma' => 'Γ',
		'\gamma' => 'γ',
		'\Delta' => '∆',
		'\delta' => 'δ',
		'\epsilon' => 'ε',
		'\zeta' => 'ζ',
		'\eta' => 'η',
		'\Theta' => 'Θ',
		'\theta' => 'θ',
		'\iota' => 'ι',
		'\kappa' => 'κ',
		'\lambda' => 'λ',
		'\mu' => 'μ',
		'\nu' => 'ν',
		'\Xi' => 'Ξ',
		'\xi' => 'ξ',
		'\Pi' => 'Π',
		'\pi' => 'π',
		'\rho' => 'ρ',
		'\Sigma' => 'Σ',
		'\sigma' => 'σ',
		'\tau' => 'τ',
		'\upsilon' => 'υ',
		'\Phi' => 'Φ',
		'\phi' => 'φ',
		'\chi' => 'χ',
		'\Psi' => 'Ψ',
		'\psi' => 'ψ',
		'\Omega' => 'Ω',
		'\omega' => 'ω',
	);

	my $text = $_[1][0];
	my @result;

	return EAT_ALL unless defined $text;

	for (split ' ', $text) {
		if (exists $replace_map{$_}) {
			push @result, $replace_map{$_};
		}
		else {
			push @result, $_;
		}
	}

	{
		$" = ' ';
		command("say @result")
	}

	return EAT_ALL;
}
