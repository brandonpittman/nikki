#!/usr/bin/env ruby

require 'fileutils'

def set_dir
    @home = "#{Dir.home}/"
    @dropbox = "#{@home}Dropbox/"
    @save_loc = Dir.exists?(@dropbox) ? @dropbox : @home
end

def set_var
    @year = Time.now.strftime('%Y')
    @f = "#{@save_loc}.kioku_#{@year}.md"
    @month = Time.now.strftime('%B')
    @day = Time.now.strftime('%e').strip
    @arg = ARGF.argv[0]
end

def check_args
	if ARGF.argv[0] == nil
		puts "No argument passed!"
		exit
	end
end

def check_existing
    `osascript -e 'tell application "System Events" to display alert "File does not exist!"'` unless File.exists?(@f) == true
end

def reset_time
    if @arg == "-r"
        FileUtils.touch @f, :mtime => Time.now-86400
        print "Modification time reset."
        exit
    end
end

def check_missed_day
    if File.mtime(@f).strftime('%F') != (Time.now-86400).strftime('%F')
        write_text
        `open -a 'Sublime Text' "#{@f}"`
        exit
    end
end

def set_text
    if @day == "1"
        @text = "\n# #{@month}\n\n#{@day}. #{@arg}"
    else
        @text = "#{@day}. #{@arg}"
    end
end

def write_text
    open(@f, 'a') { |f| f.puts @text }
end

check_args
set_dir
set_var
check_existing
reset_time
set_text
check_missed_day
write_text
