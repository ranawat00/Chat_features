class Api::ExternalChatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_external_member, only: [:start_chat]

  def search
    email = params[:email]
    external_member = ExternalMember.find_by(email: email)

    if external_member
      render json: { status: 'success', external_member: external_member }
    else
      render json: { status: 'error', message: 'Member not found' }, status: :not_found
    end
  end

  def start_chat
    external_member = ExternalMember.find_by(id: params[:external_member_id])
    return render json: { status: 'error', message: 'Member not found' }, status: :not_found if external_member.nil?

    conversation = Conversation.find_by(id: params[:conversation_id])
    return render json: { status: 'error', message: 'Conversation not found' }, status: :not_found if conversation.nil?

    user = User.find_by(id: params[:user_id])
    return render json: { status: 'error', message: 'User not found' }, status: :not_found if user.nil?

    message = Message.new(message_params)
    message.conversation = conversation
    message.user = user
    # message.external_member = external_member

    if message.save
      render json: { status: 'success', message: message }
    else
      render json: { status: 'error', errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  private

  def find_external_member
    ExternalMember.find_by(id: params[:external_member_id]) 
  end

  def message_params
    params.require(:message).permit(:body,:conversation_id, :user_id)
  end
end
