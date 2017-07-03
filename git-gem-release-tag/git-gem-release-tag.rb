#!/usr/bin/env ruby
# frozen_string_literal: true

# git-gem-release-tag: Create a git tag for a Ruby namespace's version,
#  build a new gem for that tag, and push that gem to Rubygems.

def find_gemspec(namespace)
  # __dir__ doesn't work because `git` doesn't cwd to the project for some reason
  candidates = Dir[File.join(`pwd`.chomp, "*.gemspec")]

  # if there's only one gemspec, assume it's correct
  # return candidates.first if candidates.size == 1

  # otherwise, take the first gemspec that matches the namespace
  candidates.find { |c| c =~ Regexp.new(namespace, Regexp::IGNORECASE) }
end

def act(s)
  if ARGV.include? "--dry-run"
    puts s
  else
    system s
  end
end

namespace = ARGV.shift || abort("Give me a namespace to check.")
gemspec = find_gemspec namespace.downcase

# any of these might have our version constant in them!
glob = File.join(`pwd`.chomp, "lib", "*.rb")
Dir[glob].each { |f| require_relative f }

tags = `git tag`.split
version = Object.const_get(namespace)::VERSION

abort("Did you forget to update #{namespace}::VERSION?") if tags.include?(version)
abort("No gemspec candidate found.") unless File.file?(gemspec)

specname = File.basename(gemspec, ".gemspec")

# you'd better hope each of these steps works!
act "git tag #{version}"
act "git push origin #{version}"
act "gem build #{gemspec}"
act "gem push #{specname}-#{version}.gem"
act "rm -f #{specname}-#{version}.gem"
