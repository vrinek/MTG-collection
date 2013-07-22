require "awesome_print"
require "./sets.rb"
require "./checklist.rb"
require "./input_processor.rb"
require 'open-uri'

$cards = {}

processor = InputProcessor.new(false)
LOG_FILENAME = "cards.log"
if File.exists?(LOG_FILENAME)
	File.open(LOG_FILENAME, 'r') do |log_file|
		log_file.each_line do |line|
			processor.process_input line.strip
		end
	end
end

processor = InputProcessor.new
File.open(LOG_FILENAME, 'a') do |log_file|
	loop do
		print "set: #{SETS[processor.set_code] || "NONE"} > "
		result = processor.process_input gets.strip
		if result == false
			break
		elsif result.is_a?(String)
			log_file.puts result
		end
	end
end
