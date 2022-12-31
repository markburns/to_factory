class CreateUsers < ActiveRecord::Migration[6.1]
  def up
    create_table :users do |t|
      t.column :name, :string, null: false
      t.column :email, :string
      t.integer :some_id
    end
  end

  def down
    drop_table :users
  end
end
