require 'thor'
require "pathname"
require "date"
require 'time'

module Nikki
  class Generator < Thor

    desc "new ENTRY", "Creates a new entry in the Nikki journal."
    def new(entry)
      if updated_yesterday?
        file.open('a') { |file| file.puts text(entry)}
      else
        %x{open -a TextEdit #{file}}
      end
    end

    no_commands do
      def file
       Pathname.new("#{ENV['HOME']}/.nikki_#{Time.now.strftime("%Y")}.md")
      end

      def file_exist?
        if file.exist?
          return true
        else
          create_file
          return true
        end
      end

      def create_file
        FileUtils.touch(file)
      end

      def first_of_month?
        Time.now.strftime("%d") == "1"
      end

      def date
        Time.now.strftime("%d")
      end

      def month
        Time.now.strftime("%B")
      end

      def updated_yesterday?
        file.mtime.to_date == Date.today-1
      end

      def text(entry)
        if first_of_month?
          "## #{month}\n\n#{date}. #{entry}"
        else
          "#{date}. #{entry}"
        end
      end
    end

  end
end