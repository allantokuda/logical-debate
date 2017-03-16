class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :get_agreement
  after_action :store_location

  def get_agreement
    return unless request.method == 'GET' && !(request.path =~ /\/users\//)
    session[:target_path] = request.path
    render 'public/landing' unless cookies[:agreement]
  end

  def accept_agreement
    cookies[:agreement] = { value: I18n.t('agreement.button'), expires: 365.days.from_now }
    redirect_to session[:target_path] || '/'
  end

  def store_location
    return if request.method != 'GET' || request.path =~ /\/users\//
    store_location_for(:user, request.path)
  end

  def current_user
    super || GuestUser.new
  end
end
