require "awesome_print"
require "./sets.rb"
require "./checklist.rb"
require "./input_processor.rb"
require 'open-uri'

$cards = {}

processor = InputProcessor.new(false)
LOG_FILE = "cards.log"
if File.exists?(LOG_FILE)
	File.open(LOG_FILE, 'r') do |cards_file|
		cards_file.each_line do |line|
			processor.process_input line.strip
		end
	end
end

processor = InputProcessor.new
File.open(LOG_FILE, 'a') do |cards_file|
	loop do
		print "set: #{SETS[processor.set_code] || "NONE"} > "
		result = processor.process_input gets.strip
		if result == false
			break
		elsif result.is_a?(String)
			cards_file.puts result
		end
	end
end
