class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  
  def after_sign_in_path_for(resource)
		case resource.onboarding_missing_step
	  when :step1 then step1_onboarding_path
	  when :step2 then step2_onboarding_path
	  else
	    dashboard_path
	  end
	end
	
	def after_sign_up_path_for(resource)
		after_sign_in_path_for(resource)
	end
end
