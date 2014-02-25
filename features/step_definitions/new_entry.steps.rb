require "time"
require "pathname"

Given(/^I have a (.+) to make$/) do |arg|
  @text = arg
  @file = Pathname.new("#{ENV['HOME']}/.nikki_#{Time.now.strftime("%Y")}.md")
end

When(/^I try to (save) my entry$/) do |arg|
  arg == "save"
end

When(/^the journal file can't be found$/) do
  FileUtils.rm(@file) if File.exist?(@file)
end

Then(/^a file should be created$/) do
  FileUtils.touch(@file)
end

Then(/^(my journal entry) saved$/) do |arg|
  @entry = arg
  File.open(@file,"a") { |f| f.puts "#{Time.now.strftime("%d")}. #{arg}" }
end

When(/^it's the first of the month$/) do
  @date = Date.new(2014,2,1)
end

Then(/^the name of the month as an H1 header should be appended$/) do
  File.open(@file, "a") { |file| file.puts "#{@date.strftime("%B")}" }
end

Then(/^and my (entry) should be saved$/) do |arg|
  File.open(@file, "a") { |file| file.puts "#{@date.strftime("%d").strip} #{arg}" }
end

When(/^it's not the first of the month$/) do
  @date = Date.new(2014,2,2)
end

Then(/^my (entry) should be appended along with the day of the month$/) do |arg|
  File.open(@file, "a") { |file| file.puts "#{@date.strftime("%d").strip} #{arg}" }
end

When(/^the mtime of the journal isn't yesterday$/) do
    today = Date.today
    @file.mtime.to_date != Date.today-1
end

Then(/^the journal should open in my editor$/) do
    %x{open -a 'Sublime Text' #{@file}}
end
