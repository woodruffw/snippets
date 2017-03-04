#!/usr/bin/env ruby

# giphy-fetch.rb
# Author: William Woodruff
# ------------------------
# Fetch animated GIFs from Giphy and save them to a directory.
# Requires the "slop" gem.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

require "json"
require "open-uri"
require "slop"

VERSION = 1

# fall back to public beta key, see https://github.com/Giphy/GiphyAPI
KEY = ENV["GIPHY_API_KEY"] || "dc6zaTOxFJmzC"
URL = "http://api.giphy.com/v1/gifs/search?q=%{query}&api_key=%{key}&limit=100"

opts = Slop.parse do |o|
  o.banner = <<~EOS
    Fetch animated GIFs from Giphy and save them to a directory.

    Usage:
      giphy-fetch.rb [--directory <dir>] <query>

    Example:
      giphy-fetch.rb --directory dogs "cute dogs"
  EOS

  o.string "-d", "--directory", "the output directory", default: "gifs"
  o.bool "-v", "--verbose", "be verbose"

  o.on "-V", "--version", "print the script's version" do
    puts "giphy-fetch version #{VERSION}."
    exit
  end

  o.on "-h", "--help", "print this help message" do
    puts o
    exit
  end
end

query = opts.args.shift || abort("I need a query.")

puts "Querying Giphy for '#{query}'..." if opts.verbose?

url = URL % { query: URI.encode(query), key: KEY }

begin
  response = JSON.parse(open(url).read)
  abort("Giphy didn't respond correctly.") if response["data"].empty?

  Dir.mkdir opts[:directory] unless Dir.exist?(opts[:directory])

  response["data"].each do |gif|
    filename = File.join(opts[:directory], "#{gif["id"]}.gif")
    puts "Saving #{filename}..." if opts.verbose?
    File.open(filename, "wb") do |gif_file|
      gif_file.write(open(gif["images"]["original"]["url"]).read)
    end
  end
rescue => e
  raise e
  abort("Something exploded during GIF retrieval.")
end
