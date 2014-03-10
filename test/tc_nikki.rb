require "minitest/autorun"
require "minitest/unit"
require "nikki"
require 'fileutils'

class NikkiTest < MiniTest::Unit::TestCase

  include Nikki

  nikki = Generator.new
  FileUtils.rm(nikki.file) if nikki.file_exist?
  FileUtils.rm(nikki.config_file) if nikki.config_file_exist?

  def test_file_exist?
    nikki = Generator.new
    assert_equal(true,nikki.file_exist?)
  end

  def test_read_config
    nikki = Generator.new
    assert(nikki.read_config.class == Hash)
  end

  def test_updated_yesterday?
    nikki = Generator.new
    settings = nikki.read_config
    settings[:updated] = nikki.today-1
    nikki.write_config(settings)
    assert(nikki.updated_yesterday?,"Journal wasn't updated last yesterday.")
  end

end
