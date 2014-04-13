require "time"
require "pathname"
require "nikki"

include Nikki

class Journal
  def last_updated
    Date.today
  end

  def yesterday
    Date.today - 1
  end
end

journal = Journal.new

Then(/^a file should be created$/) do
end

Given(/^:last_updated isn't yesterday$/) do
  journal.last_updated != journal.yesterday
end

Then(/^the file "(.*?)" should open in my editor$/) do |arg|
end
