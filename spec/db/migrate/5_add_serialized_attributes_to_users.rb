class AddSerializedAttributesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :some_attributes, :text
  end

  def self.down
    remove_column :users, :some_attributes
  end
end
