# Via:
# https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated

class CustomFailure < Devise::FailureApp
  def redirect_url
    # Prefer going to the Sign Up page instead of the Log In page for now
    new_user_registration_url #(:subdomain => 'secure')
  end

  # Need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
