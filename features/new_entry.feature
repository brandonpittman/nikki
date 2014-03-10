@entry_creation
Feature: Add a new entry to the journal

  Because I'm keeping a daily one-line journal, I want to be able to be able to save a new line with the day of the month next to it.

Background:
  Given I have a journal file

@file_creation
Scenario: I haven't created a journal file
  When the journal file can't be found
  Then a file should be created
  And my journal entry saved

Scenario: I have a journal file and it's the first of the month
  When it's the first of the month
  Then the name of the month as an H2 header should be appended
  And and my entry should be saved

Scenario: I have a journal file and it's *not* the first of the month
  When it's not the first of the month
  Then my entry should be appended along with the day of the month

@missed_day
Scenario: I didn't update the journal yesterday
  When the mtime of the journal isn't yesterday
  Then the journal should open in my editor
