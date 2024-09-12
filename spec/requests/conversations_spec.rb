require 'rails_helper'

RSpec.describe Api::ConversationsController, type: :controller do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let!(:conversation) { FactoryBot.create(:conversation, sender: user1, recipient: user2) }

  describe 'GET #index' do
    it 'returns a list of conversations' do
      get :index
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
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
    context 'when creating a new conversation' do
      let(:valid_params) { { sender_id: user1.id, recipient_id: user2.id } }
      it 'creates a new conversation' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(Conversation.count).to eq(1)
        expect(JSON.parse(response.body)).not_to have_key('errors')
      end

      it 'returns the created conversation' do
        post :create, params: valid_params
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response['sender_id']).to eq(user1.id)
        expect(json_response['recipient_id']).to eq(user2.id)
      end
    end

    context 'when the conversation already exists' do
      let(:existing_conversation_params) { { sender_id: user1.id, recipient_id: user2.id } }

      it 'does not create a duplicate conversation' do
        expect {
          post :create, params: existing_conversation_params
        }.not_to change(Conversation, :count)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { conversation: { sender_id: nil, recipient_id: user2.id } } }
    
      it 'returns an error message' do
        post :create, params: invalid_params
        json_response = JSON.parse(response.body)
        puts json_response 
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:valid_params) { { id: conversation.id, conversation: { recipient_id: user1.id } } }

    it 'updates the conversation' do
      put :update, params: valid_params
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response['recipient_id']).to eq(user1.id)
    end
  

    it 'returns an error if update fails' do
      put :update, params: { id: conversation.id, conversation: { sender_id: nil } }
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      # expect(json_response['sender_id']).to include("can't be blank")
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the conversation' do
      expect {
        delete :destroy, params: { id: conversation.id }
      }.to change(Conversation, :count).by(-1)
    end

    it 'returns a success message' do
      delete :destroy, params: { id: conversation.id }
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Deleted conversation')
    end
  end


end