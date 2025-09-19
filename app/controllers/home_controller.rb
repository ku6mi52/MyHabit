class HomeController < ApplicationController
	def index
		@today = Date.current
		@daily_record = current_user.daily_records.find_or_initialize_by(recorded_on: @today)
		@habits = current_user.habits.where(active: true).order(:created_at)
		
		@done_habit_ids = @daily_record.persisted? ? @daily_record.habit_checks.pluck(:habit_id) : []
	end
end
