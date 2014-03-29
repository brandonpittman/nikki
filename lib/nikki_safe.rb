require 'thor'
require "pathname"
require "yaml"
require "date"

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
    journal = read_file
    journal[month][date] = "#{entry}"
    write_file(journal)
    open unless updated_yesterday?
    write_config(settings)
    puts read_file[month][date] if options[:print]
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
  def config
    settings = read_config
    settings[:editor] = options[:editor] || read_config[:editor]
    settings[:updated] = Date.today-1 if options[:yesterday]
    settings[:updated] = Date.today if options[:today]
    write_config(settings)
    puts settings.to_yaml if options[:print]
  end

  desc "random", "Prints random Nikki entry."
  def random
    local_month = random_month
    local_month_type = month_type(local_month)
    local_date = random_date(local_month_type)
    random_memory = read_file[local_month][local_date]
    puts "#{year}-#{local_month}-#{local_date}: #{random_memory}"
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
      file.open('w') { |f| f << hash.to_yaml }
    end

    def editor
      read_config[:editor]
    end

    def file
      path.join("nikki_#{year}.yaml")
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
      write_file(months_and_days)
    end

    def marked
      Pathname.new("/Applications/Marked.app")
    end

    def today
      Date.today
    end

    def first_of_month?
      today.day == "1"
    end

    def date
      today.day
    end

    def month
      today.month
    end

    def year
      today.year
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

    def month_type(month_number)
      if [1,3,5,7,8,10,12].include?(month_number)
        :long_month
      elsif [4,6,9,11].include?(month_number)
        :short_month
      else
        :february
      end
    end

    def months_and_days
      yaml = months_with_names
      yaml.each do |k,v|
       if month_type(k) == :long_month
         (1..31).each { |n| v[n] = nil }
       elsif month_type(k) == :short_month
         (1..30).each { |n| v[n] = nil }
       else
         if Date.today.leap?
           (1..29).each { |n| v[n] = nil }
         else
           (1..28).each { |n| v[n] = nil }
         end
       end
      end
    end

    def leap_year?
      Date.today.leap?
    end

    def random_month
      if month == 1
        1
      elsif month == 2
        2
      else
        rand(month-1)+1
      end
    end

    def random_date(month_type)
      case month_type
      when :long_month
        return rand(31)
      when :short_month
        return rand(30)
      else
        leap_year? ? rand(29) : rand(28)
      end
    end

    def updated_yesterday?
      read_config[:updated] == Date.today-1
    end

    def text(entry)
      if first_of_month?
        "\n## #{month}\n\n#{date}. #{entry}"
      else
        "#{date}. #{entry}"
      end
    end
  end
end
