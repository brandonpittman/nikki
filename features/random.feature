Feature: Look up random journal entry
  As a curious person
  I want to look up random journal entries

Scenario: look up random entry
  Given a file named "nikki.yaml"
  When I run random
  Then STDOUT should contain a journal entry
