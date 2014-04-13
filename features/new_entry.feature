Feature: Add a new entry to the journal
  As someone keepings a daily one-line journal
  I want to be able to be able to save a new line with the day of the month next to it.

Scenario: I haven't created a journal file
  Given the file "nikki_2014.yaml" should not exist
  Then a file should be created
  And an empty file named "nikki_2014.yaml"
  And a file named "nikki_2014.yaml" should exist

Scenario: I didn't update the journal yesterday
  Given :last_updated isn't yesterday
  Then the file "nikki_2014.yaml" should open in my editor
