require "awesome_print"
require "./sets.rb"
require "./checklist.rb"
require "./input_processor.rb"
require 'open-uri'
require 'time'
require 'csv'

$cards = {}

processor = InputProcessor.new(false)
LOG_FILENAME = "cards.log"
SEPARATOR = ' :: '

if File.exists?(LOG_FILENAME)
	File.open(LOG_FILENAME, 'r') do |log_file|
		log_file.each_line do |line|
			processor.process_input line.split(SEPARATOR)[1].strip
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
			log_file.puts "#{Time.now.rfc2822}#{SEPARATOR}#{result}"
		end
	end
end
