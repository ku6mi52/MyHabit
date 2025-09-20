class CreateHabitChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :habit_checks do |t|
      t.references :daily_record, null: false, foreign_key: { on_delete: :cascade }
      t.references :habit, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
      t.boolean :done, null: false, default: false
    end
    add_index :habit_checks, [:daily_record_id, :habit_id], unique: true
  end
end
