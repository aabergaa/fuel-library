require 'spec_helper'
require 'shared-examples'
manifest = 'roles/mongo_primary.pp'

describe manifest do
  before (:each) do
    Puppet::Parser::Functions::newfunction(:file, :arity => -2, :type => :rvalue) do |vals|
      return 'key' if vals.first == '/var/lib/astute/mongodb/mongodb.key'
      raise Puppet::ParseError, "Could not find any files from #{vals.join(", ")}"
    end
  end

  test_ubuntu_and_centos manifest
end

