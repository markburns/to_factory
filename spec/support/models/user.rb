class ToFactory::User < ActiveRecord::Base
  self.table_name = "users"
  serialize :some_attributes, Hash
end
