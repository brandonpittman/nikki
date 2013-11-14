kioku
======

> "Record something new learned every day of the year."

### Track newly learned things

"kioku" is read as 'key-oh-coo'. In Japanese, "kioku" means memory (like a person's memory). The idea behind *kioku* is to record one thing you learned today. If all goes well, you've got a 365 line journal formatted in Markdown and ready to be posted to your blog on January 1st next year. The months are h1's and every day in the month is part of an ordered list. The program checks if you have a Dropbox folder and saves ".kioku.md" there else it saves to your home directory as a hidden file.

Should you ever happen to miss a day, *kioku* will open up the Markdown file in your default editor and you can manually update the file. Passing the -r flag to *kioku* will reset the file modification time to the previous day in the event that you write **yesterday's** line the following morning.
