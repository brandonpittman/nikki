require 'thor'
require 'pathname'
require 'yaml'
require 'date'
require 'fileutils'

# @author Brandon Pittman
# This is the main class that interfaces with Thor's methods and does all the
# heavy lifting for Nikki.  It's a bit of a "God" object. Sorries.
class Generator < Thor
  # @!group Initial Setup
  desc 'setup', 'Creates new Nikki and config files.'
  # This methods creates the ".nikki" directory, config file and journal file.
  def setup
    create_path
    create_file
    create_config_file
  end

  # @!endgroup

  # @!group Data entry
  desc 'new ENTRY', 'Creates a new entry in the Nikki journal.'
  # Add entry to journal
  # @param entry [String] entry to add to the journal
  # @param update [String] International date for update
  # @return [Hash] Returns a Hash which is then saved in a YAML file.
  # @example
  #   "nikki new 'This is a thing I learned today!'"
  # Reads the settings in from the config YAML file and changes the
  # date updated.  It does the same with the journal file, reading in the YAML
  # and merging the hash of entries, and then saves the YAML back again.
  def new(entry, update=nil)
    settings = read_config
    if update
      date = Date.parse(update)
      settings[:updated] = date
    else
      date = today
      settings[:updated] = today
    end
    entry_hash = { date => "\"#{entry}\""}
    journal = read_file.merge(entry_hash)
    write_file(journal)
    open unless updated_yesterday?
    write_config(settings)
    puts latest
  end

  desc 'missed', 'Create new entry for yesterday'
  # Creates a new entry for yesterday
  # @param entry [String]
  # @since 0.5.3
  def missed(entry)
    new(entry, (Date.today - 1).to_s)
  end
  # @!endgroup

  desc 'open', "Open current year's journal file in editor."
  # Open Nikki journal in configured text editor
  def open
    system(ENV['EDITOR'], file.to_s)
  end

  desc 'ls', 'Displays latest Nikki entries.'
  # Display Nikki's latest entires
  # @return [String]
  # @option options :sticky [String]
  def ls
    puts latest
  end

  desc 'config', "Change Nikki's settings."
  option :editor, :aliases => :e, :banner => "Set default editor to open journal file in."
  option :yesterday, :aliases => :y, :type => :boolean, :banner => "Set nikki's \"updated\" date to yesterday."
  option :today, :aliases => :t, :type => :boolean, :banner => "Set nikki's \"updated\" date to today."
  option :print, :aliases => :p, :type => :boolean, :banner => "Prints nikki's config settings."
  option :latest, :aliases => :l, :type => :boolean, :banner => "Prints latest journal entries."
  # Configure Nikki's settings
  # @param [Hash] options The options for configuring Nikki
  # @option options :editor [String] (read_config[:editor]) Sets Nikki's editor to open journal file
  # @option options :yesterday [Boolean] Set `settings[:updated]` to yesterday
  # @option options :today [Boolean] Set `settings[:updated]` to today
  # @option options :print [Boolean] Prints Nikki's configuration settings to STDOUT
  # @option options :latest [Boolean] Prints Nikki's latest entries to STDOUT
  def config
    settings = read_config
    settings[:editor] = options[:editor] || read_config[:editor]
    settings[:updated] = options[:yesterday] ? Date.today - 1 : Date.today
    write_config(settings)
    puts settings.to_yaml if options[:print]
    puts latest if options[:latest]
  end

  desc 'export YEAR', 'Export Nikki journal from YEAR as YAML'
  # @param [String] year of journal entries you wish to export
  def export(year)
    export_path = "#{path}nikki_export_#{year}.yml"
    IO.write(export_path, yamlize(read_file, year.to_i))
    puts "YAML saved to \"#{export_path}\"."
  end

  no_commands do
    def path
      Pathname.new("#{ENV['HOME']}/.nikki/")
    end

    def create_path
      path.mkdir unless path.exist?
    end

    def config_file
      path.join('nikki.config.yaml')
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
      path.join('nikki.yaml')
    end

    def config_file_exist?
      return true if config_file.exist?
      create_config_file
      true
    end

    def file_exist?
      return true if file.exist?
      create_file
      true
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

    def today
      Date.today
    end

    def yesterday
      Date.today - 1
    end

    def leap_year?
      Date.today.leap?
    end

    def last_updated
      read_config[:updated]
    end

    def updated_yesterday?
      last_updated == Date.today - 1
    end

    def latest
      list = []
      (0..3).each do |n|
        list << "#{today - n}: #{read_file[today - n]}"
      end
      list.reverse!
    end

    def yamlize(hash, year)
      string = "---\n"
      hash.each_pair do |date, sentence|
        string += "#{date}: \"#{sentence}\"\n" if date.year == year
      end
      string
    end
  end
end
