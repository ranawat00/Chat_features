# spec/requests/messages_spec.rb

require 'rails_helper'

RSpec.describe Api::MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation) }
  let(:other_conversation) { create(:conversation) }

  # Creating messages in correct order
  let!(:first_message) { create(:message, conversation: conversation, user: user, body: 'First message') }
  let!(:second_message) { create(:message, conversation: conversation, user: user, body: 'Second message') }
  

  let(:valid_attributes) { { body: 'Hello, World!', user_id: user.id } }
  let(:invalid_attributes) { { body: '', user_id: user.id } }
  let!(:message) { create(:message, conversation: conversation, user: user, body: 'Hello, World!') }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Message' do
        expect {
          post :create, params: { conversation_id: conversation.id, user_id: user.id, message: valid_attributes }, as: :json
        }.to change(Message, :count).by(1)
      end

      it 'renders a JSON response with the new message' do
        post :create, params: { conversation_id: conversation.id, user_id: user.id, message: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('Hello, World!')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Message' do
        expect {
          post :create, params: { conversation_id: conversation.id, user_id: user.id, message: invalid_attributes }, as: :json
        }.not_to change(Message, :count)
      end

      it 'renders a JSON response with errors for the new message' do
        post :create, params: { conversation_id: conversation.id, user_id: user.id, message: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        # expect(response.body).to include("Body can't be blank")
      end
    end
  end

  describe 'GET #index' do
    context 'when the conversation exists' do
      it 'returns messages ordered by creation date' do
        get :index, params: { conversation_id: conversation.id }, as: :json
        parsed_response = JSON.parse(response.body)
        messages = parsed_response['messages']
        expect(messages.map { |msg| msg['body'] }).to eq(['First message', 'Second message',"Hello, World!"])
      end
    end

    context 'when the conversation is empty' do
      it 'returns an empty list of messages' do
        get :index, params: { conversation_id: other_conversation.id }, as: :json
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['messages']).to be_empty
      end
    end
  end

  describe 'GET #show' do
    context 'when the message exists' do
      it 'returns a successful response with the message' do
        get :show, params: { conversation_id: conversation.id, id: message.id }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('Hello, World!')
      end

      it 'includes the associated user in the response' do
        get :show, params: { conversation_id: conversation.id, id: message.id }, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['user']['id']).to eq(user.id)
      end
    end

    context 'when the message does not exist' do
      it 'returns an error response' do
        get :show, params: { conversation_id: conversation.id, id: -1 }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Message not found')
      end
    end

    context 'when the conversation does not exist' do
      it 'returns an error response' do
        get :show, params: { conversation_id: -1, id: message.id }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Conversation not found')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'updates the requested message' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: valid_attributes }, as: :json
        message.reload
        expect(message.body).to eq( "Hello, World!")
      end

      it 'renders a JSON response with the updated message' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: valid_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['body']).to eq( "Hello, World!")
      end
    end

    context 'with invalid parameters' do
      it 'does not update the message and returns a success message' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: invalid_attributes }, as: :json
        message.reload
        expect(message.body).to eq( "Hello, World!") # should not change
      end

      it 'renders a success message response even with invalid attributes' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: invalid_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Updated successfully')
        expect(parsed_response['message_data']['body']).to eq( "") # original message
      end
    end

    context 'when the message does not exist' do
      it 'returns a not found response' do
        put :update, params: { conversation_id: conversation.id, id: -1, message: valid_attributes }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Message not found')
      end
    end

    context 'when the conversation does not exist' do
      it 'returns a not found response' do
        put :update, params: { conversation_id: -1, id: message.id, message: valid_attributes }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Conversation not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the message exists' do
      it 'deletes the message' do
        expect {
          delete :destroy, params: { conversation_id: conversation.id, id: message.id }, as: :json
        }.to change(Message, :count).by(-1)
      end

      it 'returns a success message' do
        delete :destroy, params: { conversation_id: conversation.id, id: message.id }, as: :json
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Message deleted successfully')
      end
    end

    context 'when the message does not exist' do
      it 'returns a not found response' do
        delete :destroy, params: { conversation_id: conversation.id, id: -1 }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Message not found')
      end
    end

    context 'when the deletion fails' do
      before do
        allow_any_instance_of(Message).to receive(:destroy).and_return(false)
      end

      it 'returns an error message' do
        delete :destroy, params: { conversation_id: conversation.id, id: message.id }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Failed to delete message')
        # expect(parsed_response['errors']).not_to be_empty
      end
    end

    context 'when the conversation does not exist' do
      it 'returns a not found response' do
        delete :destroy, params: { conversation_id: -1, id: message.id }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Conversation not found')
      end
    end
  end
end

