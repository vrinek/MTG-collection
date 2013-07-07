require "awesome_print"
require "./sets.rb"
require "./checklist.rb"
require 'open-uri'

$cards = {}
HELP_TEXT = <<-TEXT
	Enter a set code (eg. "dmg" for Dragon's Maze) to select that set.
	Enter a number to add a card to your collection.
	Enter nothing to exit the program.
TEXT
CARD_NUMBER_RX = /^(\d+)( +(-?\d+))?( *f)?$/

# BUG: `url_for` does not work with fuse cards.
def url_for(set_code, number)
	"http://magiccards.info/#{set_code}/en/#{number}.html"
end

# BUG: `img_for` does not work with fuse cards.
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
def process_input(input, verbose = true)
	if input.empty? # end of story
		ap $cards
		return false
	elsif input == "?" # help
		puts HELP_TEXT
		puts "Current collection:"
		ap $cards
		puts "Known sets:"
		ap SETS
		return nil
	elsif SETS.has_key?(input) # set code
		@set_code = input
		checklist = Checklist.new(@set_code)
		checklist.fetch!
		@cards_list = checklist.cards
		return input
	elsif input =~ CARD_NUMBER_RX # card number (and amount)
		number, _, amount, foil = input.scan(CARD_NUMBER_RX)[0]
		amount ||= 1
		set_code = foil ? @set_code + " foil" : @set_code
		$cards[set_code] ||= Hash.new(0)
		$cards[set_code][number.to_i] += amount.to_i
		if verbose
			card = @cards_list.find { |card| card[:number].to_i == number.to_i }
			ap card
		end
		return input
	else
		puts "Uknown command. Type \"?\" for help."
		return nil
	end
end

LOG_FILE = "cards.log"
if File.exists?(LOG_FILE)
	File.open(LOG_FILE, 'r') do |cards_file|
		cards_file.each_line do |line|
			process_input line.strip, false
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
