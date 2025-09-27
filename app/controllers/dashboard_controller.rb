class DashboardController < ApplicationController
  before_action :authenticate_user!

	def index
		@today = Date.current
    @daily_record = current_user.daily_records.find_by(recorded_on: @today)
		@habits = current_user.habits.order(:created_at)
		
    @goal_diff_kg = current_user.goal_weight_diff_on(@today)
    @daily_record_form = @daily_record.nil? || @daily_record.weight.blank?
  end
end
