module ApplicationHelper
  def user_for(object)
    if my(object)
      'You'
    else
      object.user.display_username
    end
  end

  def my(object)
    current_user == object.user
  end
end
