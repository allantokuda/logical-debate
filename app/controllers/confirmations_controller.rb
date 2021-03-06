class ConfirmationsController < Devise::ConfirmationsController
  def confirmation_sent
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    cookies[:successful_login] = true
    stored_location_for(resource) || root_path
  end
end
