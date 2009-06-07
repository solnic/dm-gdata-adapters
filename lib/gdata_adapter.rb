require 'gdata'
gem 'dm-core', '>=0.10.0'
require 'dm-core'

module DataMapper
  module Adapters
    
    class GdataAdapter < AbstractAdapter
      class InvalidService < StandardError; end
      class GDataNotAuthorized < StandardError; end
      class MissingConfig < StandardError; end

      SERVICE_TO_CLIENT = { :spreadsheets => GData::Client::Spreadsheets }

      attr_accessor :service
      attr_accessor :gdata

      # TODO: document
      # @api semipublic
      def authorized?
        gdata.auth_handler && !gdata.auth_handler.token.blank?
      end

      private

      # TODO: document
      # @api semipublic
      def initialize(name, options = {})
        super

        unless SERVICE_TO_CLIENT[self.service = options[:service]]
          raise InvalidService.new(options[:service])
        end

        if @options[:username] && @options[:password]
          create_connection
        else
          if self.gdata = @options[:gdata]
            raise GDataNotAuthorized.new("Provided gdata client is not authorized") unless authorized?
          else
            raise MissingConfig.new("Cannot connect without a username and password or already authorized gdata client")
          end
        end
      end

      # TODO: document
      # @api semipublic
      def create_connection
        self.gdata = SERVICE_TO_CLIENT[self.service].new
        begin
          self.gdata.clientlogin(@options[:username], @options[:password])
        rescue GData::Client::AuthorizationError => e
          raise GdataNotAuthenticated.new("Client login method failed for user #{@options[:username]}")
        end
      end
    end # class GdataAdapter

  end # module Adapters
end # module DataMapper