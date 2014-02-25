require "minitest/autorun"
require "minitest/unit"
require "nikki"

class TestCase < MiniTest::Unit::TestCase

  include Nikki

  def test_file_exist?
    nikki = Generator.new
    assert_equal(true,nikki.file_exist?)
  end

end
