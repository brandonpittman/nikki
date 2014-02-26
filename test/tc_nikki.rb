require "minitest/autorun"
require "minitest/unit"
require "nikki"

class NikkiTest < MiniTest::Unit::TestCase

  include Nikki

  def test_file_exist?
    nikki = Generator.new
    assert_equal(true,nikki.file_exist?)
  end

  def test_updated_yesterday?
    nikki = Generator.new
    file = nikki.file
    FileUtils.touch(file, :mtime => Time.now-86000)
    assert(nikki.updated_yesterday?)
  end

end
