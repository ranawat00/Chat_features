require 'rails_helper'

RSpec.describe Api::ExternalChatsController, type: :controller do

  let!(:external_member) { create(:external_member, email: 'test@example.com') }

  describe 'GET #search' do
    context 'when the external member exists' do
      it 'returns success status and the external member' do
        # Update the route to include the external_member_id
        get :search, params: { external_member_id: external_member.id, email: 'test@example.com' }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq({
         'status' => 'success',
          'external_member' => {
            'id' => external_member.id,
            'email' => external_member.email,
            'name' => external_member.name,
            'created_at' => external_member.created_at.as_json,
            'updated_at' => external_member.updated_at.as_json
          }
        })
      end
    end

    context 'when the external member does not exist' do
      it 'returns an error message' do
        get :search, params: { external_member_id: external_member.id, email: 'notfound@example.com' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({
          'status' => 'error',
          'message' => 'Member not found'
        })
      end
    end
  end

  

  describe 'POST #start_chat' do
    let!(:external_member) { create(:external_member, email: 'member@example.com') }
    let!(:user) { create(:user) }
    let!(:recipient) { create(:user) }
    let!(:conversation) { create(:conversation, sender: user, recipient: recipient) }
    let(:valid_params) do
      {
        external_member_id: external_member.id,
        conversation_id: conversation.id,
        user_id: user.id,
        message: { body: 'Hello!' }
      }
    end
    context 'when all parameters are valid' do
      it 'creates a new message and returns success' do
        post :start_chat, params: valid_params
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']['body']).to eq('Hello!')
      end
    end

    context 'when external member is not found' do
      it 'returns an error message' do
        post :start_chat, params: valid_params.merge(external_member_id: -1)
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Member not found')
      end
    end

    context 'when conversation is not found' do
      it 'returns an error message' do
        post :start_chat, params: valid_params.merge(conversation_id: -1)
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Conversation not found')
      end
    end

    context 'when user is not found' do
      it 'returns an error message' do
        post :start_chat, params: valid_params.merge(user_id: -1)
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('User not found')
      end
    end

    context 'when message is invalid' do
      it 'returns an error message' do
        post :start_chat, params: valid_params.merge(message: { body: '' })
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['errors']).to include("Body can't be blank")
      end
    end
  end

  describe 'private methods' do
    describe '#find_external_member' do
      it 'finds an external member by id' do
        post :start_chat, params: { external_member_id: external_member.id }

        # expect(assigns(:external_member)).to eq(external_member)
      end

      it 'returns nil for an invalid external member id' do
        post :start_chat, params: { external_member_id: 'invalid_id' }

        expect(assigns(:external_member)).to be_nil
      end
    end
  end


end
