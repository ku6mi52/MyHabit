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
    records_array = Array(daily_records)
    return {} if records_array.empty?

    # 最初のrecordからuser_idを取得（全て同じuserのはず）
    user_id = records_array.first.user_id
    total_tasks = Habit.where(user_id: user_id).count
    return {} if total_tasks.zero?

    # 一括でhabit_checksをロード
    record_ids = records_array.map(&:id)
    done_counts = HabitCheck.where(daily_record_id: record_ids, done: true)
                            .group(:daily_record_id)
                            .count

    # 各recordの達成率を計算
    records_array.index_by(&:id).transform_values do |record|
      done_count = done_counts[record.id] || 0
      (done_count * 100) / total_tasks
    end
  end

  def self.calculate_completion_rate(daily_record)
    # 後方互換性のため残す
    total_tasks = daily_record.user.habits.count
    return 0 if total_tasks.zero?

    done_count = daily_record.habit_checks.checked.count
    (done_count * 100) / total_tasks
  end
end
