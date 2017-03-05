class PublicController < ApplicationController
  def landing
    redirect_to statements_path if current_user.logged_in?
  end
end
