require 'fileutils'
require 'open-uri'
require 'nokogiri'
require 'json'

class Checklist
	attr_reader :set_code, :set_folder, :cards

	def initialize(set_code)
		@set_code = set_code

		@set_folder = ".sets/#{@set_code}/"
		FileUtils.mkdir_p @set_folder
	end

	def fetch!
		fetch_html
		parse_html
		save_cards
	end

	private

	def fetch_html
		html_file = File.join set_folder, "page.html"

		if File.exists?(html_file)
			File.open html_file do |file|
				@html = file.read
			end
		else
			url = "http://magiccards.info/#{@set_code}/en.html"
			File.open html_file, 'w' do |file|
				@html = open(url).read
				file << @html
			end
		end
	end

	def parse_html
		@cards = []
		Nokogiri::HTML(@html).css('tr.odd, tr.even').each do |card_tr|
			keys = %i[number name type mana_cost rarity artist sets]
			values = card_tr.css('td').map(&:text)
			card = Hash[*[keys, values].transpose.flatten]
			@cards << card
		end
	end

	def save_cards
		filename = File.join(set_folder, "cards.json")
		File.open filename, 'w' do |file|
			file.puts @cards.to_json
		end
	end
end
