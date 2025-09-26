class HabitChecksController < ApplicationController
	before_action :authenticate_user!
	
	def create
		HabitCheck.set_done!(
			user: current_user, 
			habit_id: params.require(:habit_id),
			date: (params[:recorded_on].presence || Date.current).to_date, 
			done: params[:done]
		)
		redirect_back fallback_location: dashboard_path
	end
end
