class AddBirthdayToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :birthday, :datetime
  end

  def down
    remove_column :users, :birthday
  end
end
