# kioku

> "Record something new learned every day of the year."

### Track newly learned things

"kioku" is read as 'key-oh-coo'. In Japanese, "kioku" means memory (like a person's memory). The idea behind *kioku* is to record one thing you learned today. If all goes well, you've got a 365 line journal formatted in Markdown and ready to be posted to your blog on January 1st next year. The months are h1's and every day in the month is part of an ordered list. The program checks if you have a Dropbox folder and saves ".kioku.md" there else it saves to your home directory as a hidden file.

## Installation

Add this line to your application's Gemfile:

    gem 'kioku'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kioku

## Usage

- kioku help [COMMAND]  # Describe available commands or one specific command
- kioku new ENTRY       # Creates a new entry in the Kioku journal.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/kioku/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request