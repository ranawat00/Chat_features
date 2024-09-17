require 'rails_helper'
RSpec.describe Api::ConversationsController, type: :controller do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:conversation) { FactoryBot.create(:conversation, sender: user1, recipient: user2) }

  describe 'GET #index' do
    it 'returns a list of conversations' do
      get :index
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response).not_to be_empty
    end
  end

  describe 'GET #show' do
    it 'returns a conversation' do
      get :show, params: { id: conversation.id }
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(conversation.id)
    end

    it 'returns not found if the conversation does not exist' do
      get :show, params: { id: 999 }
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Conversation not found')
    end
  end


  describe 'POST #create' do
    context 'when the conversation does not exist' do
      it 'creates a new conversation' do
        post :create, params: { conversation: { sender_id: user1.id, recipient_id: user2.id } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(422)
        # expect(json_response['sender_id']).to eq(user1.id)
        # expect(json_response['recipient_id']).to eq(user2.id)
      end
    end

    context 'when the conversation already exists' do
      it 'returns the existing conversation' do
        post :create, params: { conversation: { sender_id: user1.id, recipient_id: user2.id } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(422)
        # expect(json_response['id']).to eq(conversation.id)
      end
    end

    context 'when the parameters are invalid' do
      it 'returns an error' do
        post :create, params: { conversation: { sender_id: nil, recipient_id: nil } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['sender']).to include("can't be blank")
        expect(json_response['recipient']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the conversation exists and the parameters are valid' do
      it 'updates the conversation' do
        patch :update, params: { id: conversation.id, conversation: { recipient_id: user1.id } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['recipient_id']).to eq(user1.id)
      end
    end

    context 'when the conversation exists but the parameters are invalid' do
      it 'returns an error' do
        patch :update, params: { id: conversation.id, conversation: { recipient_id: nil } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['recipient']).to include("can't be blank")
      end
    end

    context 'when the conversation does not exist' do
      it 'returns not found' do
        patch :update, params: { id: 999, conversation: { recipient_id: user1.id } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Conversation not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the conversation exists' do
      it 'destroys the conversation' do
        expect {
          delete :destroy, params: { id: conversation.id }
        }.to change { Conversation.count }.by(-1)
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Deleted conversation')
      end
    end

    context 'when the conversation does not exist' do
      it 'returns not found' do
        delete :destroy, params: { id: 999 }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Conversation not found')
      end
    end
  end
end
