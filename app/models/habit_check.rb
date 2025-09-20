class HabitCheck < ApplicationRecord
	belongs_to :daily_record
	belongs_to :habit
	
	validates :habit_id, uniqueness: { scope: :daily_record_id }
	
	def self.set_done!(user:, habit_id:, date:, done:)
		dr = user.daily_records.find_or_create_by!(recorded_on: date)
		hc = find_or_create_by!(daily_record: dr, habit_id: habit_id)
		hc.update!(done: ActiveModel::Type::Boolean.new.cast(done))
		hc
	end
end
