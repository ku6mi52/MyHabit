# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(_resource)
    step1_onboarding_path
  end

  def after_inactive_sign_up_path_for(_resource)
    step1_onboarding_path
  end
end
