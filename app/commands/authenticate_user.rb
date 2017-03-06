class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password, registering)
    @email, @password, @registering = email, password, registering
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
      u = User.find_by_email(email)
      return registered if @registering && u.nil?
      return u if u && u.authenticate(password)

      errors.add :user_authentication, 'invalid credentials'
      nil
  end

  def registered
    new_user = User.create!(email: email, password: password)
    return new_user if new_user

    errors.add :user_authentication, 'credentials do not meet requirements'
    nil
  end
end
