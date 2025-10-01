class HabitCheck < ApplicationRecord
	belongs_to :daily_record
	belongs_to :habit
	
	validates :habit_id, uniqueness: { scope: :daily_record_id }
	
  scope :checked, -> { where(done: true) }

  def self.habit_checks_for_dashboard(user:, recorded_on:, checks: nil)
    daily_record = user.daily_records.find_or_create_by!(recorded_on: recorded_on)

    user.habits.order(:id).each do |habit|
      daily_record.habit_checks.find_or_create_by!(habit: habit)
    end

    if checks.present?
      submitted_checks = checks || {}

      daily_record.habit_checks.find_each do |habit_check|
        habit_id_key = habit_check.habit_id.to_s

        per_habit_hash = submitted_checks[habit_id_key]
        next if per_habit_hash.nil?

        submitted_done_value = per_habit_hash["done"]
        checked = (submitted_done_value == "1")

        habit_check.update!(done: checked)
      end
    end
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
