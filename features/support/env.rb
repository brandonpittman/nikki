$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require "aruba/cucumber"
require "fileutils"
require "cucumber/rspec/doubles"

# Before do
#   @real_home = ENV['HOME']
#   fake_home = File.join('/tmp','fake_home')
#   FileUtils.rm_rf fake_home, secure: true
#   ENV['HOME'] = fake_home
# end

# After do
#   ENV['HOME'] = @real_home
# end
