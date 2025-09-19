class OnboardingController < ApplicationController
  before_action :authenticate_user!

  def step1
    redirect_to step2_onboarding_path and return if current_user.start_weight.present?
  end

  def update_step1
    if current_user.update(onboarding_params_step1, context: :onboarding_step1)
      redirect_to step2_onboarding_path, notice: "現状を保存しました。"
    else
      flash.now[:alert] = "入力に誤りがあります"
      render :step1, status: :unprocessable_entity
    end
  end

  def step2; end

  def update_step2
    attrs = onboarding_params_step2.merge(onboarding_completed_at: Time.current)
    if current_user.update(attrs, context: :onboarding_step2)
      redirect_to authenticated_root_path, notice: "オンボーディングが完了しました。"
    else
      flash.now[:alert] = "入力に誤りがあります"
      render :step2, status: :unprocessable_entity
    end
  end

  private

  def onboarding_params_step1
    params.require(:user).permit(:start_weight, :start_body_fat_percentage)
  end

  def onboarding_params_step2
    params.require(:user).permit(:goal_weight, :goal_body_fat_percentage)
  end
end

