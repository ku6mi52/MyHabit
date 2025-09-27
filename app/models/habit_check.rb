class HabitCheck < ApplicationRecord
	belongs_to :daily_record
	belongs_to :habit
	
	validates :habit_id, uniqueness: { scope: :daily_record_id }
	
  scope :checked, -> { where(done: true) }

	def self.set_done!(user:, habit_id:, daily_record_id:, done:)
		daily_record = user.daily_records.find_or_create_by!(recorded_on: date)
		habit_check = find_or_create_by!(daily_record: daily_record, habit_id: habit_id)
		habit_check.update!(done: ActiveModel::Type::Boolean.new.cast(done))
		habit_check
	end

  def self.tasks_completion_rate(daily_records)
    Array(daily_records).map { |r|
      done = r.habit_checks.checked.count
      total_tasks = r.user.habits.count 
      rate = 
        if total_tasks == 0
          0
        else
          done * 100 / total_tasks
        end
      [r.id, rate]
    }.to_h
  end
end
