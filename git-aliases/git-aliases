#  git-aliases
#  Author: William Woodruff, 2014
#  aliases for common git commands, in no particular order
#  Licensed under the MIT License (http://opensource.org/licenses/MIT)

if [[ -f /usr/share/bash-completion/completions/git ]]; then
	source /usr/share/bash-completion/completions/git

	__git_complete g _git
	__git_complete gi _git_init
	__git_complete ga _git_add
	__git_complete gd _git_diff
	__git_complete gp _git_push
	__git_complete gb _git_branch
	__git_complete gck _git_checkout
	__git_complete gr _git_remote
	__git_complete gf _git_fetch
	__git_complete gm _git_merge
	__git_complete gc _git_clone
	__git_complete gmv _git_mv
	__git_complete grst _git_reset
	__git_complete grm _git_rm
	__git_complete gst _git_status
	__git_complete gs _git_show
fi

alias g='git'
alias gi='git init'
alias ga='git add --all'
alias gd='git diff'
alias gdmom='git diff master origin/master'
alias gp='git push'
alias gpom='git push origin master'
alias gb='git branch'
alias gbd='git branch -D'
alias gck='git checkout'
alias gckb='git checkout -b'
alias gckm='git checkout master'
alias gr='git remote'
alias grao='git remote add origin'
alias grau='git remote add upstream'
alias gf='git fetch'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gm='git merge'
alias gmum='git merge upstream/master'
alias gmom='git merge origin/master'
alias gc='git clone'
alias gmv='git mv'
alias grst='git reset'
alias grhh='git reset --hard HEAD'
alias grm='git rm'
alias gst='git status'
alias gs='git show'

function gcm()
{
	git commit -m "${@}"
}

function gpod()
{
	git push origin :${1}
}

function quickcommit()
{
	git add -A .
	git commit -m "${1:-no commit msg}"
	git push
}

function gfg()
{
	git clone "https://github.com/$(git config --global github.user)/${1}.git"
}

