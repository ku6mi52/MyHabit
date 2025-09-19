class HabitCheck < ApplicationRecord
  belongs_to :daily_record
  belongs_to :habit

  validates :habit_id, uniqueness: { scope: :daily_record_id }
end
