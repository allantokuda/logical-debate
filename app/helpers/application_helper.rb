module ApplicationHelper
  def user_for(object)
    if my(object)
      'You'
    else
      # Add usernames later
      'User'
    end
  end

  def my(object)
    current_user == object.user
  end
end
