class ApplicationController < ActionController::Base
  # protect_from_forgery with: :null_session, if: -> { request.format.json? }
  def not_found
    render json: { error: 'Route not found' }, status: :not_found
  end
  protected
  
    def authenticate_user
      header = request.headers['Authorization'] || params[:token]
      header = header.split(' ').last if header
      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end 
  
    attr_reader :current_user 
  
    def unauthorized_user (_exception)
      render json: { success: false, error: 'Unauthorized access denied' }, status: :unauthorized
    end
  end