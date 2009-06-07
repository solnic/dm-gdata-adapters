require File.dirname(__FILE__) + '/spec_helper'

describe DataMapper::Adapters::GdataAdapter do
  before :all do
    @adapter_class = DataMapper::Adapters::GdataAdapter
  end

  describe '#setup' do
    it 'should set up with username and password' do
      setup_adapter(:service  => :spreadsheets,
        :username => TEST_ACCOUNT[:username], :password => TEST_ACCOUNT[:password]
      ) do |adapter|
        adapter.authorized?.should be(true)
      end
    end

    it 'should set up with authorized gdata client' do
      setup_adapter(:gdata => create_gdata_client) do |adapter|
        adapter.authorized?.should be(true)
      end
    end

    it 'should fail without username and password' do
      lambda { setup_adapter }.should raise_error(@adapter_class::MissingConfig)
    end

    it 'should fail with unauthorized gdata client' do
      lambda { 
        setup_adapter(:gdata => GData::Client::Spreadsheets.new)
      }.should raise_error(@adapter_class::GDataNotAuthorized)
    end
  end

  def setup_adapter(options={})
    yield(DataMapper.setup(:default, {:adapter => :gdata, :service => :spreadsheets}.merge!(options)))
  end

  def create_gdata_client
    gdata_client = GData::Client::Spreadsheets.new
    gdata_client.clientlogin TEST_ACCOUNT[:username], TEST_ACCOUNT[:password]
    gdata_client
  end
end