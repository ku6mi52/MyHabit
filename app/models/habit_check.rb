class HabitCheck < ApplicationRecord
  belongs_to :daily_record
  belongs_to :habit

  validates :habit_id, uniqueness: { scope: :daily_record_id }

  scope :checked, -> { where(done: true) }

  def self.habit_checks_for_dashboard(user:, recorded_on:, checks: nil)
    daily_record = user.daily_records.find_or_create_by!(recorded_on: recorded_on)
    initialize_habit_checks_for_daily_record(user, daily_record)
    update_habit_checks(daily_record, checks) if checks.present?
  end

  def self.initialize_habit_checks_for_daily_record(user, daily_record)
    user.habits.order(:id).each do |habit|
      daily_record.habit_checks.find_or_create_by!(habit: habit)
    end
  end

  def self.update_habit_checks(daily_record, checks)
    daily_record.habit_checks.find_each do |habit_check|
      habit_id_key = habit_check.habit_id.to_s
      per_habit_hash = checks[habit_id_key]
      next if per_habit_hash.nil?

      checked = per_habit_hash["done"] == "1"
      habit_check.update!(done: checked)
    end
  end

  def self.tasks_completion_rate(daily_records)
    Array(daily_records).index_by(&:id).transform_values do |record|
      calculate_completion_rate(record)
    end
  end

  def self.calculate_completion_rate(daily_record)
    total_tasks = daily_record.user.habits.count
    return 0 if total_tasks.zero?

    done_count = daily_record.habit_checks.checked.count
    (done_count * 100) / total_tasks
  end
end
