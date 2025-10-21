class DashboardController < ApplicationController
  before_action :authenticate_user!

	def index
		@today = Date.current
    @daily_record = current_user.daily_records.find_or_create_by(recorded_on: @today)
		@habits = current_user.habits.order(:created_at)
		
    @goal_diff_kg = current_user.goal_weight_diff_on(@today)
    @daily_record_form = @daily_record.nil? || @daily_record.weight.blank?

    @habit_checks = @habits.map do |habit|
      @daily_record.habit_checks.find_or_create_by!(habit: habit)
    end

    start = Time.zone.today.beginning_of_month
    finish = Time.zone.today.end_of_month

    @this_month_daily_records = current_user.daily_records.where(recorded_on: start..finish).select(:id, :recorded_on, :weight, :user_id).order(:recorded_on)

    rates_by_id = HabitCheck.tasks_completion_rate(@this_month_daily_records) || {}
    last_day = finish.day
    labels   = (1..last_day).to_a
    weights  = Array.new(last_day)
    rates    = Array.new(last_day)
    @this_month_daily_records.each do |r|
      d = r.recorded_on.day
      weights[d - 1] = r.weight
      rates[d - 1] = rates_by_id[r.id]
    end

    @chart_data = { labels:, weights:, rates: }
  end
end

