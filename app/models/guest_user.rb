class GuestUser < User
  def created_at
    Time.now
  end

  def logged_in?
    false
  end
end
