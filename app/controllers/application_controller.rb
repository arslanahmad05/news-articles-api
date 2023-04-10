class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_sanitized_params, if: :devise_controller?

  def configure_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :email, :password, :password_confirmation, :admin
    ])
  end
end
