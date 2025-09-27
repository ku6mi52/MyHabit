class HabitChecksController < ApplicationController
	before_action :authenticate_user!
	
	def create
    p = habit_check_params
    HabitCheck.set_done!(
      user: current_user, 
      habit_id: p[:habit_id],
      daily_record_id: p[:daily_record_id], 
      done: p[:done]
    )
		redirect_back fallback_location: dashboard_path
	end

  private

  def habit_check_params
    params.require(:habit_check).permit(:habit_id, :daily_record_id, :done)
  end
end
