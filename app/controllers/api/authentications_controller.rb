class Api::AuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :login,:sign_up]

  def sign_up
    user_params = signup_params
    
    company_name = user_params.delete(:company)
    company = Company.find_or_create_by(name: company_name) if company_name.present?
    user = User.new(user_params)
    user.company = company if company
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, message: 'Signup successful', user: user.as_json(include: :company) }, status: :created
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
  def current_user
    @my_conversations = Conversation.includes(:messages, :recipient).where("sender_id = ? OR recipient_id = ?", @current_user.id, @current_user.id)
    render json: {
      success: true,
      data: {my_conversations: @my_conversations.as_json(include: {
        sender: { only: [:id, :email] },
        recipient: { only: [:id, :email, :type] },
        messages: { include: { user: { only: [:id, :email] } } }
      })
    }
  }, status: :ok
  end
  private
  def generate_token(user)
    JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
  end
  def signup_params
    params.require(:user).permit(:password, :email, :first_name, :last_name, :company)
  end
end