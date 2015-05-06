#!/usr/bin/env ruby
#  -*- coding: utf-8 -*-
#  xdcc.rb
#  Author: Mahdi Bchetnia, William Woodruff
#  ------------------------
#  An Cinch XDCC file fetcher, modified from https://github.com/inket/RubyXDCCGetter
#  The original does not appear to be under any license, so this one will
#  remain in the public domain.

begin
	require 'cinch'
rescue Exception => e
	abort('Fatal: The cinch gem is required.')
end

class Helper
	def self.human_size(n, base = 8)
		return "0" if n.nil?
		
		units = ['B', 'KB', 'MB', 'GB']
	
		unit = units[0]
		size = n
	
		if (n.instance_of?(String))
			unit = n[-2, 2]
			size = n[0..-2].to_f
		end
	
		if ((size >= 1024 && base == 8) || (size >= 1000 && base == 10))
			human_size((base == 8 ? (size / 1024) : (size / 1000)).to_s + units[units.index(unit) + 1], base)
		else
			if (size == size.to_i)
				return size.to_i.to_s + unit
			else
				index = size.to_s.index(".")
				
				return size.to_s[0..(index - 1)] + unit if units.index(unit) < 2
				
				begin
					return size.to_s[0..(index + 2)] + unit
				rescue
					return size.to_s[0..(index + 1)] + unit
				end
			end
		end
	end
end

if (ARGV[0..2].compact.size < 3)
	abort('Usage: ruby xdcc.rb <server> <bot_name> <file_number> [-c <channel_name>] [-d <download_folder>]')
end

i = 0
@@server = nil
@@bot_name = nil
@@file_number = nil
@@channel_name = nil
@@download_folder = nil

ARGV.delete_if do |x|
	if (i == 0)
		@@server = x
	elsif (i == 1)
		@@bot_name = x
	elsif (i == 2)
		@@file_number = x
	else
		if (x == '-d')
			ARGV.shift
			@@download_folder = File.expand_path(ARGV.first)+"/"
			if (!File.directory?(@@download_folder))
				abort("'#{@@download_folder}' is not a folder.")
			end
		elsif (x == '-c')
			ARGV.shift
			@@channel_name = ARGV.first
		end
	end

	i += 1
	true
end

puts "Server: #{@@server}"
puts "Bot name: #{@@bot_name}"
puts "Requested file: #{@@file_number}"
puts "Join channel: #{'#' if @@channel_name}#{@@channel_name || '<none>'}"
puts "Download folder: #{@@download_folder || Dir.pwd}"
puts "----------------\n"

@@helper = Helper.new

class XDCC
	attr :bot, :bot_thread
	attr_reader :handler

	def initialize(server, optional_channel)
		@bot = Cinch::Bot.new do
			configure do |c|
				c.server = server || 'irc.rizon.net'
				c.nick = 'Guest' + Time.now.to_f.to_s.gsub(".", "")[10..-1]
				c.channels = ["##{optional_channel}"] if optional_channel
				c.plugins.plugins = [XDCCHandler]
			end
		end

		puts 'Starting bot...'
		@bot_thread = Thread.new(@bot) do |bot|
			bot.loggers.level = :fatal
			bot.start
		end

		puts 'Connecting...'

		while (@bot.plugins.first.nil?)
			sleep 1
		end
		@handler = @bot.plugins.first
	end
end

class XDCCHandler
	include Cinch::Plugin
	attr :download
	attr_reader :connected, :waiting_download
	attr_accessor :download_folder

	def start_download(user, file)
		@waiting_download = {:user => user, :file => file}
		ask_for_dl
	end

	listen_to :connect, method: :on_connect
	def on_connect(m)
		puts 'Connected.'
		@connected = true
		ask_for_dl
	end

	def ask_for_dl
		if (@connected && @waiting_download && @waiting_download[:requested].nil?)
			puts "Asking #{@waiting_download[:user]} for download #{@waiting_download[:file]}..."
			User(@waiting_download[:user]).send("xdcc send #{@waiting_download[:file]}")
			@waiting_download[:requested] = true
		end
	end

	listen_to :dcc_send, method: :incoming_dcc
	def incoming_dcc(m, dcc)
		if (@waiting_download)
			user = @waiting_download[:user].downcase
			file = @waiting_download[:file]

			remote_user = dcc.user.nick.downcase
			filename = dcc.filename
			filesize = dcc.size

			if (user == remote_user)
				puts 'Received response:'
				puts "File: #{filename}"
				puts "Size: #{Helper.human_size(filesize)}\n"

				puts 'Starting download...'

				download_thread = create_download_thread(dcc, @download_folder)
				progress_thread = create_progress_thread(download_thread)

				puts 'Download started.'

				@download = {
					:user => user, :file => file, :filename => filename,
					:download_thread => download_thread,
					:progress_thread => progress_thread
				}

				@waiting_download = nil
			end
		else
			puts "Ignoring XDCC request from '#{dcc.user.nick}' as it is not expected."
		end
	end

	def create_download_thread(dcc_, download_dir_ = "")
		download_dir_ = download_dir_ || ""
		Thread.new(dcc_, download_dir_) do |dcc, download_dir|
			Thread.current['dcc'] = dcc
			Thread.current['download_dir'] = download_dir

			save_path = "#{download_dir}#{dcc.filename}"
			Thread.current['file'] = save_path

			t = File.open("#{save_path}", "w")
			dcc.accept(t)
			puts 'Download finished.'
			t.close
		end
	end

	def create_progress_thread(download_thread)
		Thread.new(download_thread) do |dl_thread|

			sleep 2
			dcc = dl_thread['dcc']
			file = dl_thread['file']

			total_size = dcc.size || 0
			size = 0

			Thread.current['total_size'] = total_size

			while (dl_thread.alive?)
				sleep 1

				new_size = File.size(file)
				Thread.current['speed'] =  new_size - size
				Thread.current['progress'] = (total_size != 0 ? ((new_size.to_f / total_size.to_f) * 100).to_i : 0)
				Thread.current['size'] = new_size

				size = new_size
			end
		end
	end

	def download
		if (@download && @download[:progress_thread]['total_size'])
		{
			:filename => @download[:filename],
			:downloading => @download[:download_thread].alive?,
			:progress => @download[:progress_thread]['progress'] || 0,
			:speed => @download[:progress_thread]['speed'],
			:size => @download[:progress_thread]['size'],
			:total_size => @download[:progress_thread]['total_size']
		}
		end
	end
end

begin
	xdcc = XDCC.new(@@server, @@channel_name)
	xdcc.handler.download_folder = @@download_folder
	xdcc.handler.start_download(@@bot_name, @@file_number)

	while (xdcc.bot_thread.alive? && (xdcc.handler.download.nil? || xdcc.handler.download[:downloading]))
		sleep 1

		download = xdcc.handler.download
		if (download)
			puts "#{Helper.human_size(download[:size])}/#{Helper.human_size(download[:total_size])} (#{download[:progress]}%) - #{Helper.human_size(download[:speed])}/s"
		end
	end

	puts 'Download finished. Quitting...'
	xdcc.bot.quit

rescue Interrupt
	abort('User canceled download. Quitting...')
rescue Exception => e
	raise e
end
