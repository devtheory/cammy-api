class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])
    check_command(command)
  end

  def register
    command = AuthenticateUser.call(params[:email], params[:password], true)
    check_command(command)
  end

  private

  def check_command(command)
    if command.success?
      render json: {auth_token: command.result}
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end
end
