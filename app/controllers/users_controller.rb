class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate params[:username], params[:password]
  end

  def test
    render json: {
          status: "success",
          message: 'You have passed authentication and authorization test'
        }
  end

  # POST /register
  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def root
    render json: {
      message: "Study With Quizzes API..." 
    }
  end 

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :is_admin
    )
  end

  def authenticate(username, password)
    command = AuthenticateUser.call(username, password)

    if command.success?
      render json: {
        access_token: command.result,
        is_admin: command.user.is_admin,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
