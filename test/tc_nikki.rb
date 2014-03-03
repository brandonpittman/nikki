require "minitest/autorun"
require "minitest/unit"
require "nikki"
require 'fileutils'

class NikkiTest < MiniTest::Unit::TestCase

  include Nikki

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
    assert(nikki.updated_yesterday?)
  end

end
