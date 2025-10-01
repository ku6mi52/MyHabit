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
  end
end

