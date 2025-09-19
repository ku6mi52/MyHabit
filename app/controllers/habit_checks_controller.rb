class HabitChecksController < ApplicationController
	before_action :authenticate_user!
	def toggle
		habit = current_user.habits.find(params[:habit_id])
    dr = current_user.daily_records.find_or_create_by!(recorded_on: Date.current)
    check = dr.habit_checks.find_by(habit_id: habit.id)
		if check
			check.destroy!
		else
			dr.habit_checks.create!(habit: habit)
		end
		
		redirect_back fallback_location: authenticated_root_path
	end
end
