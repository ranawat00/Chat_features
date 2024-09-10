class Api::AuthenticationsController < ApplicationController

  def login
    user = User.find_by(email: params[:email])
    if user && user.valid_password?(params[:password])
      token = generate_token(user)
      render json: { message: 'Login successful', user: user }, status: :ok
    else
      render json: { error: 'Invalid email  or password' }, status: :unauthorized
    end
  end


  def sign_up
    user = User.new(signup_params)
    if user.save
      token = generate_token(user)
      render json: { token: token,message: 'Signup successful', user: user }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
  def generate_token(user)
    
    JWT.encode({ user_id: user.id }, 
    Rails.application.credentials.secret_key_base) 
  end

  def signup_params
    params.require(:user).permit(:password, :email, :first_name, :last_name ,:company)
  end   

end
