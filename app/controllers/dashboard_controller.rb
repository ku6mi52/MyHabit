class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @today = Date.current
    @daily_record = current_user.daily_records.find_or_create_by(recorded_on: @today)
    @habits = current_user.habits.order(:created_at)
    @goal_diff_kg = current_user.goal_weight_diff_on(@today)
    @daily_record_form = @daily_record.weight.blank?
    @habit_checks = initialize_habit_checks
    @chart_data = build_monthly_chart_data
  end

  private

  def initialize_habit_checks
    @habits.map do |habit|
      @daily_record.habit_checks.find_or_create_by!(habit: habit)
    end
  end

  def build_monthly_chart_data
    start_date = Time.zone.today.beginning_of_month
    end_date = Time.zone.today.end_of_month

    records = current_user.daily_records
                          .where(recorded_on: start_date..end_date)
                          .select(:id, :recorded_on, :weight, :user_id)
                          .order(:recorded_on)

    rates_by_id = HabitCheck.tasks_completion_rate(records) || {}
    last_day = end_date.day

    labels = (1..last_day).to_a
    weights = Array.new(last_day)
    rates = Array.new(last_day)

    records.each do |record|
      day_index = record.recorded_on.day - 1
      weights[day_index] = record.weight
      rates[day_index] = rates_by_id[record.id]
    end

    { labels: labels, weights: weights, rates: rates }
  end
end
