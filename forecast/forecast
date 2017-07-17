#!/usr/bin/env ruby

# forecast.rb
# Author: William Woodruff
# ------------------------
# Fetches a weather forecast for a given query from Wunderground.
# Requires the "wunderground" gem.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

begin
  require "wunderground"
rescue LoadError
  abort "I need the 'wunderground' gem."
end

KEY = ENV["WUNDERGROUND_API_KEY"]

abort("I need a $WUNDERGROUND_API_KEY in your environment.") unless KEY

wunder = Wunderground.new(KEY)
query = ARGV.join(" ")

abort("I need a weather query.") if query.empty?

begin
  forecast = wunder.forecast_for(query)["forecast"]

  # even period numbers are day forecasts, odds are night forecasts
  days = forecast["txt_forecast"]["forecastday"].select { |w| w["period"].even? }
rescue => e
  puts "Something blew up: #{e.to_s}."
end

days.each do |day|
  puts "#{day["title"]} - #{day["fcttext"]}"
end
