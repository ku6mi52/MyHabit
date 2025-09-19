class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  
  def after_sign_in_path_for(resource)
	  if resource.onboarding_missing_step == :step1
		  onboarding_step1_path
		elsif resource.onboarding_missing_step == :step2
			onboarding_step2_path
		else
			root_path
		end
	end
	
	def after_sign_up_path_for(resource)
		after_sign_in_path_for(resource)
	end
end
