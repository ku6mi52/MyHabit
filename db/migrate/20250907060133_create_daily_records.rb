class CreateDailyRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :recorded_on, null: false
      t.float :weight
      t.float :body_fat_percentage

      t.timestamps
    end

    add_index :daily_records, [ :user_id, :recorded_on ], unique: true
  end
end
