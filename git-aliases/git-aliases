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
	__git_complete gcln _git_clone
	__git_complete gmv _git_mv
	__git_complete grst _git_reset
	__git_complete grm _git_rm
	__git_complete gst _git_status
	__git_complete gs _git_show
	__git_complete gc _git_commit
	__git_complete glg _git_log
fi

alias g='git'
alias gi='git init'
alias ga='git add --all'
alias gd='git diff'
alias gp='git push'
alias gb='git branch'
alias gbd='git branch -D'
alias gck='git checkout'
alias gckb='git checkout -b'
alias gr='git remote'
alias grao='git remote add origin'
alias grau='git remote add upstream'
alias gf='git fetch'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gm='git merge'
alias gcln='git clone'
alias gmv='git mv'
alias grst='git reset'
alias grhh='git reset --hard HEAD'
alias grm='git rm'
alias gst='git status'
alias gs='git show'
alias gc='git commit'
alias glg='git log --graph --date-order --oneline --all'

function __git_find_main_branch() {
  mapfile -t branches < <(git branch --format='%(refname:short)')
  for branch in "${branches[@]}"; do
    [[ "${branch}" == "main" || "${branch}" == "master" ]] \
      && echo -n "${branch}" \
      && return
  done
}

function gcm() {
	git commit -m "${@}"
}

function gpod() {
	git push origin :"${1}"
}

function quickcommit() {
	git add -A .
	git commit -m "${1:-no commit msg}"
	git push
}

function gfg() {
	git clone "git@github.com:$(git config --global github.user)/${1}.git"
}

function gpom() {
	git push origin "$(__git_find_main_branch)"
}

function gckm() {
	git checkout "$(__git_find_main_branch)"
}

function gmum() {
	git merge "upstream/$(__git_find_main_branch)"
}

function gm0m() {
	git merge "origin/$(__git_find_main_branch)"
}

function gdmom {
	git diff "$(__git_find_main_branch)" "origin/$(__git_find_main_branch)"
}
