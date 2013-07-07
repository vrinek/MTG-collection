class InputProcessor
	CARD_NUMBER_RX = /^(\d+)( +(-?\d+))?( *f)?$/
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
				"13", number 13 (quantity is 1 by default)
				"13 2", number 13, quantity 2
				"13 f", number 13, foil
				"13f", same as above
				"13 5 f", number 13, quantity 5, foil
				"13 -1", number 13, quantity -1 (removes 1 card from the collection)
		Enter a set code followed by a card number to add a card.
			Syntax is:
				"<set_code> <number> (<quantity>) (f)"
				"dgm 13 2", set "Dragon's Maze", number 13, quantity 2
				"m13 42 f", set "Magic 2013", number 42, foil
		Enter nothing to exit the program.
		Other commands:
			"sets": displays the list of all known sets
			"help/?": displays this help text
			"cards": displays current card collection
	TEXT

	attr_reader :set_code

	def initialize(verbose = true)
		@verbose = verbose
	end

	def process_input(input)
		if input.empty?
			end_processing
		elsif input == "?" || input == "help"
			display_help
		elsif input == "cards"
			display_card_collection
		elsif input =~ /^cards \w+$/
			set_code = input[/^cards (\w+)$/, 1]
			display_cards_for set_code
		elsif input == "sets"
			display_known_sets
		elsif SETS.has_key?(input.split[0])
			change_set input.split[0]

			rest_of_input = input.sub(/^\w+ /, '')
			if rest_of_input != input && rest_of_input =~ CARD_NUMBER_RX
				add_card rest_of_input
			end
			input
		elsif input =~ CARD_NUMBER_RX
			add_card input
		else
			puts "Uknown command. Type \"?\" for help."
		end
	end

	private

	def end_processing
		return false
	end

	def display_help
		puts HELP_TEXT
	end

	def display_card_collection
		puts "Current collection:"
		$cards.each do |set_code, card_numbers|
			puts SETS[set_code] || "foils"
			rarities = Hash.new(0)
			set_code = set_code.sub(/ foil$/, '')
			cards_list = cards_list_for(set_code)
			card_numbers.each do |(number, quantity)|
				card = find_card(number, cards_list)
				rarities[card[:rarity]] += quantity
			end
			rarities.each do |rarity, quantity|
				puts "%4d %s"%[quantity, rarity]
			end
		end
	end

	def display_cards_for(set_code)
		set_name = SETS[set_code]
		puts "Cards in #{set_name}:"
		cards_list = cards_list_for(set_code)
		$cards[set_code].each do |(number, quantity)|
			card = find_card(number, cards_list)
			puts "%3d x %3d - %s (%s)"%[quantity, number, card[:name], card[:rarity]]
		end
		if $cards[set_code + " foil"]
			puts "Foil cards in #{set_name}:"
			$cards[set_code + " foil"].each do |(number, quantity)|
				card = find_card(number, cards_list)
				puts "%3d x %3d - %s (%s)"%[quantity, number, card[:name], card[:rarity]]
			end
		end
	end

	def display_known_sets
		puts "Known sets:"
		ap SETS
	end

	def change_set(input)
		@set_code = input
		@cards_list = Checklist.new(@set_code).tap(&:fetch!).cards
		return input
	end

	def add_card(input)
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
		if @verbose
			card = find_card(number, @cards_list)
			ap card
			next_ten = @cards_list.select do |card|
				card[:number] > number.to_i && card[:number] <= number.to_i + 10
			end
			next_ten.sort_by { |card| card[:number] }.each do |card|
				puts "%3d - %s"%[card[:number], card[:name]]
			end
		end
		return input
	end

	def find_card(number, cards_list)
		cards_list.find { |card| card[:number] == number.to_i }
	end

	def cards_list_for(set_code)
		Checklist.new(set_code.sub(/ foil$/, '')).tap(&:fetch!).cards
	end
end
