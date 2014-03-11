require 'thor'
require "pathname"
require "yaml"
require "date"

module Nikki
  class Generator < Thor

    desc "new ENTRY", "Creates a new entry in the Nikki journal."
    option :print, :aliases => :p, :type => :boolean, :banner => "Will run \`tail\` on the journal file after write."
    def new(*args)
      settings = read_config
      settings[:updated] = today
      entry = args.join(" ")
      file.open('a') { |file| file.puts text(entry)}
      open unless updated_yesterday?
      write_config(settings)
      puts %x{tail #{file}} if options[:tail]
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
    option :display, :aliases => :d, :type => :boolean, :banner => "Display nikki's config settings."
    def config
      settings = read_config
      settings[:editor] = options[:editor] || read_config[:editor]
      settings[:updated] = Date.today-1 if options[:yesterday]
      settings[:updated] = Date.today if options[:today]
      puts settings.to_yaml
      write_config(settings)
    end

    no_commands do
      def path
        home = Pathname.new("#{ENV['HOME']}/")
      end

      def config_file
        path.join(".nikki.config.yaml")
      end

      def read_config
        config_file_exist?
        YAML.load(config_file.read)
      end

      def write_config(hash)
        config_file.open('w') { |t| t << hash.to_yaml }
      end

      def editor
        read_config[:editor]
      end

      def file
        path.join(".nikki_#{Time.now.strftime("%Y")}.md")
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
        FileUtils.touch(config_file)
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

      def first_of_month?
        today.day == "1"
      end

      def date
        today.day
      end

      def month
        today.month
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
end
