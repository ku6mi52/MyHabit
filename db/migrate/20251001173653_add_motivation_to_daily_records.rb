class AddMotivationToDailyRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_records, :motivation, :integer, null: true
  end
end
