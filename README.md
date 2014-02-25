<<<<<<< HEAD
# Kioku

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'kioku'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kioku

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/kioku/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======
kioku
======

> "Record something new learned every day of the year."

### Track newly learned things

"kioku" is read as 'key-oh-coo'. In Japanese, "kioku" means memory (like a person's memory). The idea behind *kioku* is to record one thing you learned today. If all goes well, you've got a 365 line journal formatted in Markdown and ready to be posted to your blog on January 1st next year. The months are h1's and every day in the month is part of an ordered list. The program checks if you have a Dropbox folder and saves ".kioku.md" there else it saves to your home directory as a hidden file.

### Error Handling

Should you ever happen to miss a day, *kioku* will open up the Markdown file in your default editor and you can manually update the file. Passing the -r flag to *kioku* will reset the file modification time to the previous day in the event that you write **yesterday's** line the following morning.
>>>>>>> f81665bccd16c1a42bab86632a3bf9fd4d080625
