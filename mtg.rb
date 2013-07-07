require "awesome_print"
require "./sets.rb"
require "./checklist.rb"
require 'open-uri'

$cards = {}
HELP_TEXT = <<-TEXT
	Enter a set code to select that set.
		Examples:
			"dmg", for "Dragon's Maze"
			"m13", for "Magic 2013"
	Enter a number to add a card to your collection.
		After the number, you can specify the quantity and whether it's a foil.
		Syntax is:
			"<number> (<quantity>) (f)"
		Examples:
			"13 2", number 13, quantity 2
			"13 f", number 13, foil (quantity is 1 by default)
			"13f", same as above
			"13 5 f", number 13, quantity 5, foil
			"13 -1", number 13, quantity -1 (removes 1 card from the collection)
	Enter nothing to exit the program.
	Other commands:
		"sets": displays the list of all known sets
		"help/?": displays this help text
		"cards": displays current card collection
TEXT
CARD_NUMBER_RX = /^(\d+)( +(-?\d+))?( *f)?$/

# @return String, nil, false
# 	`String` to log
# 	`nil` to not log
# 	`false` to exit
def process_input(input, verbose = true)
	if input.empty? # end of story
		return false
	elsif input == "?" || input == "help" # display help
		puts HELP_TEXT
	elsif input == "cards" # display cards collection
		puts "Current collection:"
		$cards.each do |set_code, card_numbers|
			puts SETS[set_code] || "foils"
			rarities = Hash.new(0)
			set_code = set_code.sub(/ foil$/, '')
			cards_list = Checklist.new(set_code).tap(&:fetch!).cards
			card_numbers.each do |(number, quantity)|
				card = cards_list.find { |card| card[:number].to_i == number.to_i }
				rarities[card[:rarity]] += 1
			end
			rarities.each do |rarity, quantity|
				puts "%4d %s"%[quantity, rarity]
			end
		end
	elsif input =~ /^cards \w+$/
		set_code = input[/^cards (\w+)$/, 1]
		set_name = SETS[set_code]
		puts "Cards in #{set_name}:"
		cards_list = Checklist.new(set_code).tap(&:fetch!).cards
		$cards[set_code].each do |(number, quantity)|
			card = cards_list.find { |card| card[:number].to_i == number.to_i }
			puts "%3d x %3d - %s (%s)"%[quantity, number, card[:name], card[:rarity]]
		end
		puts "Foil cards in #{set_name}:"
		$cards[set_code + " foil"].each do |(number, quantity)|
			card = cards_list.find { |card| card[:number].to_i == number.to_i }
			puts "%3d x %3d - %s (%s)"%[quantity, number, card[:name], card[:rarity]]
		end
	elsif input == "sets" # list of known sets
		puts "Known sets:"
		ap SETS
		return nil
	elsif SETS.has_key?(input) # change set
		@set_code = input
		@cards_list = Checklist.new(@set_code).tap(&:fetch!).cards
		return input
	elsif input =~ CARD_NUMBER_RX # add/remove card to collection
		number, _, amount, foil = input.scan(CARD_NUMBER_RX)[0]
		amount ||= 1
		set_code = foil ? @set_code + " foil" : @set_code
		$cards[set_code] ||= Hash.new(0)
		$cards[set_code][number.to_i] += amount.to_i
		if $cards[set_code][number.to_i] == 0
			$cards[set_code].delete number.to_i
		elsif $cards[set_code][number.to_i] < 0
			raise "The card collection cannot contain negative quantities of cards"
		end
		if verbose
			card = @cards_list.find { |card| card[:number].to_i == number.to_i }
			ap card
			next_ten = @cards_list.select do |card|
				card[:number].to_i > number.to_i && card[:number].to_i <= number.to_i + 10
			end
			next_ten.sort_by { |card| card[:number].to_i }.each do |card|
				puts "%3d - %s"%[card[:number], card[:name]]
			end
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
