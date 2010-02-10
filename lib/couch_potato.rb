require 'couchrest'
require 'json'
require 'json/add/core'
require 'json/add/rails'

require 'ostruct'

JSON.create_id = 'ruby_class'

module CouchPotato
  Config = Struct.new(:database_name, :validation_framework).new
  Config.validation_framework = :validatable # default to the validatable gem for validations

  # Returns a database instance which you can then use to create objects and query views. You have to set the CouchPotato::Config.database_name before this works.
  def self.database
    @@__database ||= Database.new(self.couchrest_database)
  end

  # Returns the underlying CouchRest database object if you want low level access to your CouchDB. You have to set the CouchPotato::Config.database_name before this works.
  def self.couchrest_database
    @@__couchrest_database ||= CouchRest.database(full_url_to_database)
  end

  private

  def self.full_url_to_database
    raise('No Database configured. Set CouchPotato::Config.database_name') unless CouchPotato::Config.database_name
    if CouchPotato::Config.database_name.match(%r{https?://})
      CouchPotato::Config.database_name
    else
      "http://127.0.0.1:5984/#{CouchPotato::Config.database_name}"
    end
  end
end

require File.dirname(__FILE__) + '/core_ext/object'
require File.dirname(__FILE__) + '/core_ext/time'
require File.dirname(__FILE__) + '/core_ext/date'
require File.dirname(__FILE__) + '/core_ext/string'
require File.dirname(__FILE__) + '/core_ext/symbol'
require File.dirname(__FILE__) + '/couch_potato/validation'
require File.dirname(__FILE__) + '/couch_potato/persistence'
require File.dirname(__FILE__) + '/couch_potato/railtie' if defined?(Rails)
