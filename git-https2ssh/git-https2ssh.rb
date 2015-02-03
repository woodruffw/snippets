#!/usr/bin/env ruby

#	git-https2ssh.rb
#	Author: William Woodruff
#	------------------------
#	Converts https remotes in git repos into ssh remotes.
#	Incredibly unsafe. Don't use this.
#	------------------------
#	This program is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

system('git rev-parse 2> /dev/null') or abort('No git repository found. Exiting.')

remote_info = `git remote -v`

if remote_info.empty?
	abort('No remotes to change.')
end

if remote_info.match(/git@/)
	abort('This repo is already using ssh remotes.')
end

user = remote_info.match(/(?:.+\/)(.+)(?:\/.+).git/)[1]
repo = remote_info.match(/[^\/]+.git/)

puts "Found user #{user} and repository #{repo}. Changing remote..."

`git remote set-url origin git@github.com:#{user}/#{repo}`

puts "Looks good."
