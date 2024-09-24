class Api::ConversationsController < ApplicationController
    before_action :set_conversation, only: [:show]
    skip_before_action :verify_authenticity_token, only: [:create,:index]


    def index
      @conversations = Conversation.all
      if params[:sort].present?
        if params[:sort] == 'asc'
          @conversations = @conversations.joins(:sender).order('users.name ASC')  # Sort by sender's name
        elsif params[:sort] == 'desc'
          @conversations = @conversations.joins(:sender).order('users.name DESC')
        end
      end
      render json: @conversations.as_json(include: { sender: { only: :name }, recipient: { only: :name } }), status: :ok
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
