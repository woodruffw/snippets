#!/usr/bin/env ruby

#  twitter-github-bot.rb
#  Author: William Woodruff
#  ------------------------
#  Uses GitHub's webhooks API to post repo release notifications to Twitter.
#  Depends on twitter, sinatra, and json.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT


require 'twitter'
require 'sinatra'
require 'json'

not_found do
	'404. Try again.'
end

error do
	'Internal error. Try again.'
end

post '/endpoint' do
	payload = request.body.read
	verify(payload)
	data = JSON.parse(payload)
	event = request.env["HTTP_X_GITHUB_EVENT"]
	twitter_update(data, event)
end

def verify(payload)
	sig = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
		ENV['GITHUB_WEBHOOK_SECRET'], payload)
	return halt 500, "Bad signature." unless Rack::Utils.secure_compare(sig, request.env['HTTP_X_HUB_SIGNATURE'])
end

def twitter_update(data, event)
	client = Twitter::REST::Client.new do |config|
	  config.consumer_key = ENV['WOODRUFW_TWITTER_CONSUMER_KEY']
	  config.consumer_secret = ENV['WOODRUFW_TWITTER_CONSUMER_SECRET']
	  config.access_token = ENV['WOODRUFW_TWITTER_TOKEN']
	  config.access_token_secret = ENV['WOODRUFW_TWITTER_TOKEN_SECRET']
	end

	if event == "release" # ignore other events for the time being
		repo_name = data['repository']['name']

		update_data = repo_name
		update_data += " release: " + data['release']['tag_name'] + "\n"
		update_data += "Get it at: " + data['release']['tarball_url']

		if update_data.length > 140
			update_data = update_data[0..137]
			update_data += '...'
		end

		client.update(update_data)
	end
end
