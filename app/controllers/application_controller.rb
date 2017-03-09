class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :get_agreement

  def get_agreement
    return unless request.method == 'GET'
    session[:target_path] = request.path
    render 'public/landing' unless cookies[:agreement]
  end

  def accept_agreement
    cookies[:agreement] = { value: I18n.t('agreement.button'), expires: 365.days.from_now }
    redirect_to session[:target_path] || '/'
  end

  def current_user
    super || GuestUser.new
  end
end
