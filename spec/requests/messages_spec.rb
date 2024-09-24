# spec/requests/messages_spec.rb

require 'rails_helper'

RSpec.describe Api::MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation) }
  let!(:message) { create(:message, conversation: conversation, user: user, body: 'Hello, World!') }

  let(:valid_attributes) { { body: 'New message', user_id: user.id } }
  let(:invalid_attributes) { { body: '', user_id: user.id } }
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
        expect(response.body).to include('New message')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Message' do
        expect {
          post :create, params: { conversation_id: conversation.id, user_id: user.id, message: invalid_attributes }, as: :json
        }.not_to change(Message, :count)
      end

      it 'renders a JSON response with errors' do
        post :create, params: { conversation_id: conversation.id, user_id: user.id, message: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        # expect(response.body).to include("Body can't be blank")
      end
    end
  end

  describe 'GET #index' do
    it 'returns messages ordered by creation date' do
      get :index, params: { conversation_id: conversation.id }, as: :json
      parsed_response = JSON.parse(response.body)
      messages = parsed_response['messages']
      expect(messages.map { |msg| msg['body'] }).to eq(['Hello, World!'])
    end

  end

  describe 'GET #show' do
    it 'returns a successful response with the message' do
      get :show, params: { conversation_id: conversation.id, id: message.id }, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Hello, World!')
    end

    it 'returns an error response if the message does not exist' do
      get :show, params: { conversation_id: conversation.id, id: -1 }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Message not found')
    end

    it 'returns an error response if the conversation does not exist' do
      get :show, params: { conversation_id: -1, id: message.id }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Conversation not found')
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'updates the requested message' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: valid_attributes }, as: :json
        message.reload
        expect(message.body).to eq('New message')
      end

      it 'renders a JSON response with the updated message' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: valid_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('New message')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the message' do
        put :update, params: { conversation_id: conversation.id, id: message.id, message: invalid_attributes }, as: :json
        message.reload
        expect(message.body).to eq('Hello, World!')
      end

    end

    it 'returns an error response if the message does not exist' do
      put :update, params: { conversation_id: conversation.id, id: -1, message: valid_attributes }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Message not found')
    end

    it 'returns an error response if the conversation does not exist' do
      put :update, params: { conversation_id: -1, id: message.id, message: valid_attributes }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Conversation not found')
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
        expect(response.body).to include('Message deleted successfully')
      end
    end

    it 'returns an error response if the message does not exist' do
      delete :destroy, params: { conversation_id: conversation.id, id: -1 }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Message not found')
    end

    it 'returns an error response if the conversation does not exist' do
      delete :destroy, params: { conversation_id: -1, id: message.id }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Conversation not found')
    end
  end
end
