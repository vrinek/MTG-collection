require "awesome_print"
require "./sets.rb"
require 'open-uri'

$cards = {}
HELP_TEXT = <<-TEXT
	Enter a set code (eg. "dmg" for Dragon's Maze) to select that set.
	Enter a number to add a card to your collection.
	Enter nothing to exit the program.
TEXT

def url_for(set_code, number)
	"http://magiccards.info/#{set_code}/en/#{number}.html"
end

def img_for(set_code, number)
	"http://magiccards.info/scans/en/#{set_code}/#{number}.jpg"
end

def name_for(set_code, number)
	open(url_for(set_code, number)).read[/<title>([^<]+)<\/title>/, 1]
end

# @return String, nil, false
# 	`String` to log
# 	`nil` to not log
# 	`false` to exit
def process_input(input)
	if input.empty? # end of story
		ap $cards
		return false
	elsif input == "?"
		puts HELP_TEXT
		puts "Current collection:"
		ap $cards
		return nil
	elsif input =~ /^\d+$/ # card number
		$cards[@set_code][input.to_i] += 1
		return input
	else # set code
		if SETS.has_key?(input)
			@set_code = input
			$cards[@set_code] ||= Hash.new(0)
			return input
		else
			puts "Wrong key"
			ap SETS
			return nil
		end
	end
end

LOG_FILE = "cards.log"
if File.exists?(LOG_FILE)
	File.open(LOG_FILE, 'r') do |cards_file|
		cards_file.each_line do |line|
			process_input line.strip
		end
	end
end

File.open(LOG_FILE, 'a') do |cards_file|
	loop do
		print "set: #{SETS[@set_code.to_s]} > "
		result = process_input gets.strip
		if result == false
			break
		elsif result.is_a?(String)
			cards_file.puts result
		end
	end
end
