class CreateNotNamespaced < ActiveRecord::Migration[6.1]
  def up
    create_table :not_namespaced_active_record_class_but_long_enough_it_shouldnt_cause_conflicts do |t|
      t.column :name, :string, null: false
    end
  end

  def down
    drop_table :not_namespaced_active_record_class_but_long_enough_it_shouldnt_cause_conflicts
  end
end
