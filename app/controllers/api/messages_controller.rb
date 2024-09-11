class Api::MessagesController < ApplicationController
    before_action :set_conversation
    skip_before_action :verify_authenticity_token, only: [:create]
  
    def create
      @message = @conversation.messages.build(message_params)
      @message.user = current_user  
      if @message.save
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Conversation not found' }, status: :not_found
    end
  
    def message_params
      params.require(:message).permit(:body) 
    end
end