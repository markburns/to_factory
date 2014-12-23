class CreateNotNamespaced < ActiveRecord::Migration
  def self.up
    create_table :not_namespaced_active_record_class_but_long_enough_it_shouldnt_cause_conflicts do |t|
      t.column :name, :string, :null => false
    end
  end

  def self.down
    drop_table :not_namespaced_active_record_class_but_long_enough_it_shouldnt_cause_conflicts
  end
end
