Feature: Add a new entry to the journal

  Because I'm keeping a daily one-line journal, I want to be able to be able to save a new line with the day of the month next to it.

Background:
  Given I have a journal entry to make

Scenario: I haven't created a journal file
  When I try to save my entry
  And the journal file can't be found
  Then a file should be created
  And my journal entry saved

Scenario: I have a journal file and it's the first of the month
  When I try to save my entry
  And it's the first of the month
  Then the name of the month as an H1 header should be appended
  And and my entry should be saved

Scenario: I have a journal file and it's *not* the first of the month
  When I try to save my entry
  And it's not the first of the month
  Then my entry should be appended along with the day of the month
