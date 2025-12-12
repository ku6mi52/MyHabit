class DashboardService
  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def call
    {
      daily_record: find_or_create_daily_record,
      habits: fetch_habits,
      goal_diff_kg: calculate_goal_diff,
      daily_record_form: daily_record_form?,
      habit_checks: initialize_habit_checks,
      chart_data: build_monthly_chart_data
    }
  end

  private

  attr_reader :user, :date

  def find_or_create_daily_record
    @daily_record ||= user.daily_records.find_or_create_by(recorded_on: date)
  end

  def fetch_habits
    @habits ||= user.habits.order(:created_at)
  end

  def calculate_goal_diff
    user.goal_weight_diff_on(date)
  end

  def daily_record_form?
    find_or_create_daily_record.weight.blank?
  end

  def initialize_habit_checks
    fetch_habits.each do |habit|
      find_or_create_daily_record.habit_checks.find_or_create_by!(habit: habit)
    end
    # N+1問題を防ぐためにhabitをプリロード
    find_or_create_daily_record.habit_checks.includes(:habit).to_a
  end

  def build_monthly_chart_data
    ChartDataBuilder.new(user: user, date: date).build
  end
end
