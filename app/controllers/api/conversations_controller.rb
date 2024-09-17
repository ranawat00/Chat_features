class Api::ConversationsController < ApplicationController
    before_action :set_conversation, only: [:show,:destroy,:update]
    skip_before_action :verify_authenticity_token, only: [:create]


    def index
        @conversations = Conversation.all
        render json: @conversations
    end 
    
    def show
        @conversation = Conversation.find(params[:id])
        render json: @conversation
      
    end

    def create
        if Conversation.between(params[:sender_id], params[:recipient_id]).present?
            @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
        else
            @conversation = Conversation.new(conversation_params)
        end
        
        if @conversation.save
            render json: @conversation, status: :created
        else
            render json: @conversation.errors, status: :unprocessable_entity
        end
    end
        
    
        
    def update
        if @conversation.update(conversation_params)
            render json: @conversation
        else
            render json: @conversation.errors, status: :unprocessable_entity
        end
    end

    def destroy 
        @conversation.destroy
        render json: {message: "Deleted conversation"}
    end

    private

    def set_conversation
      @conversation = Conversation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Conversation not found' }, status: :not_found
    end

    def conversation_params
        params.require(:conversation).permit(:sender_id, :recipient_id)
    end
end
