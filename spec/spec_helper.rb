require 'rubygems'
gem 'rspec'
require 'spec'

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'couch_potato'

CouchPotato::Config.database_name = 'couch_potato_test'
CouchPotato::Persistence.Db.delete!

class User
  include CouchPotato::Persistence
  
  has_many :comments, :stored => :inline
end

class Commenter
  include CouchPotato::Persistence
  
  has_many :comments, :stored => :separately
end

class Comment
  include CouchPotato::Persistence
  
  validates_presence_of :title
  
  property :title
  belongs_to :commenter
end


def sp(*args)
  puts '<pre>'
  args.each do |arg|
    puts "#{arg.inspect}"
  end
  puts '</pre>'
end