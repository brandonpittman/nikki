Feature: Look up random journal entry
  As a curious person
  I want to look up random journal entries

Scenario: look up random entry
  Given a file named "nikki.yaml"
  When I run random
  Then STDOUT should match "\d{4}-\d{2}-\d{2}: .+\."
