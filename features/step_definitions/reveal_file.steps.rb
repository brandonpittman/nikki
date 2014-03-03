require "pathname"
require "fileutils"

def file
  path = Pathname.new("/tmp/journal.md")
end

Given(/^the file doesn't exist$/) do
  FileUtils.rm_rf(file) if file.exist?
end

Then(/^create the file$/) do
  FileUtils.touch(file)
end

Then(/^reveal the file$/) do
  %x{open -a 'Sublime Text' #{file}}
end

Given(/^the file does exist$/) do
  FileUtils.touch(file) unless file.exist?
end