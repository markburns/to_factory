class AddSerializedAttributesToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :some_attributes, :text
  end

  def down
    remove_column :users, :some_attributes
  end
end
