Feature: Reveal journal file

Scenario: I try to reveal a journal file
  Given the file doesn't exist
  Then create the file
  And reveal the file

  Given the file does exist
  Then reveal the file
