require "minitest/autorun"
require "minitest/unit"
require "kioku"

class TestCase < MiniTest::Unit::TestCase

  include Kioku

  def test_file_exist?
    kioku = Generator.new
    assert_equal(true,kioku.file_exist?)
  end

end
