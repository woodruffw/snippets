#!/usr/bin/env ruby
# frozen_string_literal: true

require "slop"

# rubyvm-dump.rb
# Author: William Woodruff
# ------------------------
# Dump a Ruby script as a compiled sequence of instructions.
# Requires the "slop" gem.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

VERSION = 1

opts = Slop.parse do |o|
  o.banner = <<~EOS
    Dump a Ruby script as a compiled sequence of instructions.
    Saves the result with a .vm suffix.

    Usage:
      rubyvm-dump [--marshal] <file>
  EOS

  o.bool "-m", "--marshal", "Serialize the instructions (not human readable)"

  o.on "-V", "--version", "print the script's version" do
    puts "rubyvm-dump version #{VERSION}."
    exit
  end

  o.on "-h", "--help", "print this help message" do
    puts o
    exit
  end
end

input        = opts.args.shift || abort("I need a file to dump.")
output       = "#{input}.vm"
source       = File.read(input)
instructions = RubyVM::InstructionSequence.new source

contents = if opts.marshal?
             Marshal.dump(instructions.to_a)
           else
             instructions.disasm
           end

File.write(output, contents)
