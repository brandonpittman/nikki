require 'thor'
require "pathname"
require "yaml"
require "date"
require 'fileutils'

class Generator < Thor

  desc "setup", "Creates new Nikki and config files."
  def setup
    create_path
    create_file
    create_config_file
  end

  desc "new ENTRY", "Creates a new entry in the Nikki journal."
  option :print, :aliases => :p, :type => :boolean, :banner => "Will print saved entry."
  def new(*args)
    settings = read_config
    settings[:updated] = today
    entry = args.join(" ")
    entry_hash = { last_updated + 1 => entry }
    journal = read_file.merge(entry_hash)
    write_file(journal)
    open unless updated_yesterday?
    write_config(settings)
    puts latest
  end

  desc "open", "Open current year's journal file in editor."
  option :marked, :aliases => :m, :type => :boolean
  def open
    if options[:marked]
      %x{open -a Marked #{file}}
    else
      %x{open -a "#{editor}" #{file}}
    end
  end

  desc "config", "Change Nikki's settings."
  option :editor, :aliases => :e, :banner => "Set default editor to open journal file in."
  option :yesterday, :aliases => :y, :type => :boolean, :banner => "Set nikki's \"updated\" date to yesterday."
  option :today, :aliases => :t, :type => :boolean, :banner => "Set nikki's \"updated\" date to today."
  option :print, :aliases => :p, :type => :boolean, :banner => "Prints nikki's config settings."
  option :latest, :aliases => :l, :type => :boolean, :banner => "Prints last seven journal entries."
  def config
    settings = read_config
    settings[:editor] = options[:editor] || read_config[:editor]
    settings[:updated] = Date.today-1 if options[:yesterday]
    settings[:updated] = Date.today if options[:today]
    write_config(settings)
    puts settings.to_yaml if options[:print]
    puts latest if options[:latest]
  end

  no_commands do
    def path
      Pathname.new("#{ENV['HOME']}/.nikki/")
    end

    def create_path
      path.mkdir unless path.exist?
    end

    def config_file
      path.join("nikki.config.yaml")
    end

    def read_config
      create_path
      config_file_exist?
      YAML.load(config_file.read)
    end

    def write_config(hash)
      config_file.open('w') { |t| t << hash.to_yaml }
    end

    def read_file
      create_path
      file_exist?
      YAML.load(file.read)
    end

    def write_file(hash)
      file.write(hash.to_yaml)
    end

    def editor
      read_config[:editor]
    end

    def file
      path.join("nikki.yaml")
    end

    def config_file_exist?
      return true if config_file.exist?
      create_config_file
      return true
    end

    def file_exist?
      return true if file.exist?
      create_file
      return true
    end

    def create_config_file
      settings = {}
      settings[:updated] = today
      settings[:editor] = 'TextEdit'
      write_config(settings)
    end

    def create_file
      FileUtils.touch(file)
    end

    def marked
      Pathname.new("/Applications/Marked.app")
    end

    def today
      Date.today
    end

    def months_with_names
      {1=>{:name=>"January"},
      2=>{:name=>"February"},
      3=>{:name=>"March"},
      4=>{:name=>"April"},
      5=>{:name=>"May"},
      6=>{:name=>"June"},
      7=>{:name=>"July"},
      8=>{:name=>"August"},
      9=>{:name=>"September"},
      10=>{:name=>"October"},
      11=>{:name=>"November"},
      12=>{:name=>"December"}}
    end

    def leap_year?
      Date.today.leap?
    end

    def last_updated
      read_config[:updated]
    end

    def updated_yesterday?
      last_updated == Date.today-1
    end

    def latest
      list = []
      (0..3).each do |n|
        list << "#{today-n}: #{read_file[today-n]}"
      end
      list.reverse!
    end
  end
end
