class DashboardController < ApplicationController
  before_action :authenticate_user!

	def index
		@today = Date.current
    @daily_record = current_user.daily_records.find_by(recorded_on: @today)
		@habits = current_user.habits.where(active: true).order(:created_at)
		
		@done_habit_ids = current_user.done_habit_ids_on(@today)
    @goal_diff_kg = current_user.goal_weight_diff_on(@today)
    @show_quick_form = @daily_record.nil? || @daily_record.weight.blank?
  end
end
