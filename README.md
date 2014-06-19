[![Gem Version](https://badge.fury.io/rb/nikki.png)](http://badge.fury.io/rb/nikki)
[![Inline docs](http://inch-ci.org/github/brandonpittman/nikki.png)](http://inch-ci.org/github/brandonpittman/nikki)

# nikki

> "Record something new learned every day of the year."

### Track newly learned things

In Japanese, "nikki" means "daily journal". The idea behind *nikki* is to record one thing you learned today. If all goes well, you've got a 365 line journal formatted in Markdown and ready to be posted to your blog on January 1st next year. The months are H1's and every day in the month is part of an ordered list. The journal file is saved at `~/.nikki_#{year}.md`.

## Installation

Add this line to your application's Gemfile:

    gem 'nikki'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nikki

## Usage

    nikki config          # Change Nikki's settings.
    nikki help [COMMAND]  # Describe available commands or one specific command
    nikki new ENTRY       # Creates a new entry in the Nikki journal.
    nikki open            # Open current year's journal file in editor.
    nikki setup           # Creates new Nikki and config files.

## Examples

### New entry
    nikki new "Brandon Pittman is a super cool guy."

### Configure Nikki
    nikki config --yesterday  # Reset last updated `datetime`
    nikki config --list       # Prints latest entries

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nikki/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
