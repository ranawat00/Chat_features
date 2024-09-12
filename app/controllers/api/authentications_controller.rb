class Api::AuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:login, :sign_up]

  def sign_up
    user = User.new(signup_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
     
      render json: { token: token, message: 'Signup successful', user: user }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by(email: params[:email]) 
    if user && user.valid_password?(params[:password]) 
      token = JsonWebToken.encode(user_id: user.id) 
      expiration_time = 24.hours.from_now
      render json: { accessToken: token, user: user}, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  
  private

  def generate_token(user)
    JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) 
  end

  def signup_params
    params.require(:user).permit(:password, :email, :first_name, :last_name, :company)
  end
end
