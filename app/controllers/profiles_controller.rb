class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show ;end

  def edit_goals
    @user = current_user
  end

  def update_goals
    if current_user.update(goals_params)
      redirect_to profile_path, notice: "目標を更新しました！"
    else
      flash.now[:alert] = "更新に失敗しました"
      @user = current_user
      render :edit_goals, status: :unprocessable_entity
    end
  end

  private
  def goals_params
    params.require(:user).permit(:goal_weight, :goal_body_fat_percentage)
  end
end
