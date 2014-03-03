require 'thor'
require "pathname"
require "yaml"
require "date"
require 'time'

module Nikki
  class Generator < Thor
    @@config = nil

    desc "new ENTRY", "Creates a new entry in the Nikki journal."
    def new(entry)
      file.open('a') { |file| file.puts text(entry)}
      open unless updated_yesterday?
      @@config = config
      @@config[:updated] = Date.today
      config_file.open('w') { |t| t << @@config.to_yaml }
    end

    desc "open", "Opens current year's journal file in editor."
    def open
      %x{open -a "#{editor}" #{file}}
    end

    desc "setup", "Change Nikki's settings."
    option :editor, :aliases => :e
    def setup
      @@config = config
      @@config[:editor] = options[:editor] || 'TextEdit'
      config_file.open('w') { |t| t << @@config.to_yaml }
    end

    no_commands do
      def path
        dropbox = Pathname.new("#{ENV['HOME']}/Dropbox/")
        home = Pathname.new("#{ENV['HOME']}/")
        path = dropbox.exist? ? dropbox : home
      end

      def config_file
        path.join(".nikki.config.yaml")
      end

      def config
        config_file_exist?
        YAML.load(config_file.read)
      end

      def editor
        config[:editor]
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
      end

      def create_file
        FileUtils.touch(file)
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
        config[:updated] == Date.today-1
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