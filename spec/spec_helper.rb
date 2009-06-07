require 'spec'

$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'gdata_adapter'

TEST_ACCOUNT = {:username => ENV['DM_ADAPTERS_USERNAME'], :password => ENV['DM_ADAPTERS_PASSWORD']}
