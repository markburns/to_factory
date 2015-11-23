class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :name, :string, null: false
      t.column :objective, :string
      t.integer :some_id
    end
  end

  def self.down
    drop_table :projects
  end
end
