class HabitChecksController < ApplicationController
  before_action :authenticate_user!

  def today_tasks_update
    recorded_on = Date.current

    HabitCheck.habit_checks_for_dashboard(
      user: current_user,
      recorded_on: recorded_on,
      checks: habit_check_params
    )
    redirect_to dashboard_path, notice: "習慣チェックを記録しました！"
  end

  private

  def habit_check_params
  params.require(:habit_checks).to_unsafe_h.transform_values { |v| ActionController::Parameters.new(v).permit(:done) }
  end
end
