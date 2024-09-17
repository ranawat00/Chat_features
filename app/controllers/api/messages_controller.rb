class Api::MessagesController < ApplicationController
    before_action :set_conversation
    before_action :set_message, only: [:show,:update,:destroy]
    skip_before_action :verify_authenticity_token, only: [:create, :update,:destroy]
  
    def create
      @message = @conversation.messages.build(message_params)
      @message.user = User.find(params[:user_id])  
      if @message.save
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end

    def index
      @messages = @conversation.messages.includes(:user).order(created_at: :asc)
      render json: {
        conversation: @conversation,
        messages: @messages.as_json(include: :user)
      }
    end

    def show
      render json: @message, include: :user
    end

    def update 
      if @message.update(message_params)
        render json: @message, status: :ok
      else
        render json: { message: "Updated successfully", message_data: @message }, status: :ok
      end
    end 

    def destroy
      if @message.destroy
        render json: { message: "Message deleted successfully" }, status: :ok
      else
        render json: { message: "Failed to delete message", errors: @message.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
  
    private

    def set_message
      @message = @conversation.messages.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Message not found' }, status: :not_found
    end
  
    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Conversation not found' }, status: :not_found
    end
  
    def message_params
      params.require(:message).permit(:body,) 
    end
end