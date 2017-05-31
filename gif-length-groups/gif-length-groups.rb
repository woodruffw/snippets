#!/usr/bin/env ruby
# frozen_string_literal: true

require "slop"

# gif-length-groups.rb
# Author: William Woodruff
# ------------------------
# Given N gifs, organize them into random groups such that each group
# has a total timespan of K seconds, within one second. Then, combine
# each group of GIFs into one GIF and save it in the given directory.
# Requires the "slop" gem.
# Requires exiftool, gifsicle.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

VERSION = 1

def self.installed?(util)
  ENV["PATH"].split(File::PATH_SEPARATOR).any? do |path|
    File.executable?(File.join(path, util))
  end
end

EXTERNAL_DEPS = %w[exiftool gifsicle].freeze

EXTERNAL_DEPS.each do |dep|
  abort "Missing dependency: '#{dep}'." unless installed? dep
end

opts = Slop.parse do |o|
  o.banner = <<~EOS
    Group GIFs into random groups of similar total length, then combine
    those groups into singlular GIFs and save them.

    Usage:
      gif-length-groups [-n <groups>] [-l <len>] [-i <len>] [-d <dir>] <gifs ...>

    Example:
      gif-length-groups -l 60 -d groups *.gif
  EOS

  o.int "-n", "--num-groups", "the number of groups to build", default: 100
  o.int "-l", "--group-length", "the length of each group (secs)", default: 60
  o.int "-i", "--input-limit", "the max length of each input (secs)", default: 10
  o.string "-d", "--directory", "the output directory", default: "groups"
  o.bool "-q", "--quiet", "be quiet"

  o.on "-V", "--version", "print the script's version" do
    puts "gif-length-groups version #{VERSION}."
    exit
  end

  o.on "-h", "--help", "print this help message" do
    puts o
    exit
  end
end

inputs = opts.args

puts "Got #{inputs.size} inputs..." unless opts.quiet?

puts "Calculating durations..." unless opts.quiet?

durations = inputs.map do |input|
  `exiftool -q -Duration '#{input}'`.split(/\s+/)[2].to_f
end

puts "Longest input: #{durations.max}s" unless opts.quiet?

inputs_map = inputs.zip(durations).to_h

groups = []

opts[:num_groups].times do |g|
  group_duration = 0
  puts "Building group #{g}" unless opts.quiet?
  groups[g] = []

  while group_duration < opts[:group_length]
    input = inputs_map.keys.sample

    next if inputs_map[input] >= opts[:input_limit]
    next if inputs_map[input] + group_duration > opts[:group_length] + 1

    groups[g] << input
    group_duration += inputs_map[input]
  end

  puts "Group #{g} duration: #{group_duration}" unless opts.quiet?
end

puts "Rendering grouped GIFs..." unless opts.quiet?

Dir.mkdir opts[:directory] unless Dir.exist? opts[:directory]

groups.each_with_index do |gifs, i|
  filename = File.join(opts[:directory], "group#{i}.gif")
  `gifsicle -w --colors 256 #{gifs.join(" ")} > #{filename}`

  puts "Rendered group #{i} as #{filename}..." unless opts.quiet?
end
