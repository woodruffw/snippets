#!/usr/bin/env ruby

#	albumart.rb
#	Author: William Woodruff
#	------------------------
#	Fetch an album's cover art using Last.fm's search API.
#	Only retrieves large and extralarge images.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'open-uri'
require 'json'

QUERY = ARGV.shift
KEY = ENV["LASTFM_API_KEY"]
URL = "http://ws.audioscrobbler.com/2.0/?method=album.search" \
	"&album=%{query}" \
	"&api_key=%{key}" \
	"&format=json"

abort("Usage: #{$PROGRAM_NAME} <query>") unless QUERY
abort("Fatal: Missing environment: LASTFM_API_KEY.") unless KEY

url = URL % { query: QUERY, key: KEY }

begin
	response = JSON.parse(open(url).read)
rescue OpenURI::HTTPError => e
	abort "Fatal: #{e.to_s}"
end

images = response["results"]["albummatches"]["album"].first["image"]

image = images.find { |i| i["size"] == "extralarge" }
image = images.find { |i| i["size"] == "large" } unless image

abort("Fatal: Couldn't find a sufficiently large image.") unless image

begin
	File.write('cover.png', open(image["#text"]).read)
rescue OpenURI::HTTPError => e
	abort "Fatal: #{e.to_s}"
end
