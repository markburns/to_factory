class CreateProjects < ActiveRecord::Migration[6.1]
  def up
    create_table :projects do |t|
      t.column :name, :string, null: false
      t.column :objective, :string
      t.integer :some_id
    end
  end

  def down
    drop_table :projects
  end
end
