# this is for rails only

config_file_path = "#{Rails.root}/config/couchdb.yml"
if File.exist?(config_file_path)
  require File.dirname(__FILE__) + '/../lib/couch_potato'

  CouchPotato::Config.database_name = YAML::load(File.read(config_file_path))[RAILS_ENV]

  RAILS_DEFAULT_LOGGER.info "** couch_potato: initialized from #{__FILE__}"
end
