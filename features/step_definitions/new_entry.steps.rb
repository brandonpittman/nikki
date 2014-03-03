require "time"
require "pathname"
require "nikki"

include Nikki

Given(/^I have a journal file$/) do
  @nikki = Generator.new
  @file = @nikki.file
  FileUtils.touch(@file) unless @file.exist?
end

When(/^the journal file can't be found$/) do
  FileUtils.rm(@file) if File.exist?(@file)
end

Then(/^a file should be created$/) do
  FileUtils.touch(@file)
end

Then(/^(my journal entry) saved$/) do |arg|
  File.open(@file,"a") { |f| f.puts @nikki.text(arg) }
end

When(/^it's the first of the month$/) do
  @first = Date.new(2014,2,1)
end

Then(/^the name of the month as an H2 header should be appended$/) do
  File.open(@file, "a") { |file| file.puts "\n## #{@first.strftime("%B").strip}\n\n" }
end

Then(/^and my (entry) should be saved$/) do |arg|
  File.open(@file, "a") { |file| file.puts "#{@first.strftime("%e").strip}. #{arg}" }
end

When(/^it's not the first of the month$/) do
  @not_first = Date.new(2014,2,2)
end

Then(/^my (entry) should be appended along with the day of the month$/) do |arg|
  File.open(@file, "a") { |file| file.puts "#{@not_first.strftime("%e").strip}. #{arg}" }
end

When(/^the mtime of the journal isn't yesterday$/) do
    today = Date.today
    @file.mtime.to_date != Date.today-1
end

Then(/^the journal should open in my editor$/) do
    %x{open -a 'Sublime Text' #{@file}}
end
