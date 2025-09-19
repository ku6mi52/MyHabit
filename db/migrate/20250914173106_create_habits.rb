class CreateHabits < ActiveRecord::Migration[7.2]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :difficulty, null: false, default: 0
      t.date :started_on
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :habits, [:user_id, :name], unique: true
  end
end
