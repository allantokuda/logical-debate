class SessionsController < Devise::SessionsController
  after_action :note_successful_login, only: [:create]

  def smart_auth
    if cookies[:successful_login]
      redirect_to [:new_user_session]
    else
      redirect_to [:new_user_registration]
    end
  end

  def note_successful_login
    cookies[:successful_login] = true
  end
end
