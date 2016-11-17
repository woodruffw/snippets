#!/usr/bin/env ruby

#	liferea-yt-feed.rb
#	Author: William Woodruff
#	------------------------
#	Adds a YouTube channel to Liferea.
#	Works with both old (/user/) and new (/channel/)-style YouTube channels.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'uri'

DEPS = [
	"liferea",
	"liferea-add-feed",
	"pidof"
]

YOUTUBE_FEED_URLS = {
	chan: "https://www.youtube.com/feeds/videos.xml?channel_id=%{id}",
	user: "https://www.youtube.com/feeds/videos.xml?user=%{id}"
}

def which?(cmd)
	ENV['PATH'].split(File::PATH_SEPARATOR).any? do |path|
		File.executable?(File.join(path, cmd))
	end
end

def running?(cmd)
	`pidof '#{cmd}'`
	$?.success?
end

def add_feed!(feed_url)
	`liferea-add-feed '#{feed_url}' 1>&2 2>/dev/null`
	$?.success?
end

abort "Usage: #{$PROGRAM_NAME} <channel url>" unless ARGV.length > 0

DEPS.each { |d| abort "Fatal: Missing '#{d}'." unless which? d }

abort "Fatal: liferea needs to be running." unless running? "liferea"

chan_url = URI(ARGV.shift)

if chan_url.host.nil? || /youtube/i !~ chan_url.host || chan_url.path.empty?
	abort "Fatal: Not a valid channel URL."
end

type, id = chan_url.path.split('/')[1..2]

case type
when "channel"
	feed_url = YOUTUBE_FEED_URLS[:chan] % { id: id }
when "user"
	feed_url = YOUTUBE_FEED_URLS[:user] % { id: id }
else
	abort "Fatal: Ambiguous channel URL (or not a channel URL)."
end

print "Adding #{feed_url} to Liferea..."

print add_feed!(feed_url) ? "success.\n" : "failure!\n"
