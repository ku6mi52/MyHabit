class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    service = DashboardService.new(user: current_user)
    result = service.call

    @today = Date.current
    @daily_record = result[:daily_record]
    @habits = result[:habits]
    @goal_diff_kg = result[:goal_diff_kg]
    @daily_record_form = result[:daily_record_form]
    @habit_checks = result[:habit_checks]
    @chart_data = result[:chart_data]
  end
end
