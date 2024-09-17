require 'rails_helper'
RSpec.describe Api::ExternalChatsController, type: :controller do
  describe 'GET #search' do
    let!(:external_member) { create(:external_member, email: 'test@example.com') }

    context 'when the external member exists' do
      it 'returns the external member and a success status' do
        get :search, params: { external_member_id: external_member.id, email: 'test@example.com' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(status: 'success', external_member: { id: external_member.id, email: 'test@example.com' })
      end
    end

    context 'when the external member does not exist' do
      it 'returns a not found status and an error message' do
        get :search, params: { external_member_id: external_member.id, email: 'nonexistent@example.com' }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json(status: 'error', message: 'Member not found')
      end
    end
  end



  describe 'POST #start_chat' do
    let(:external_member) { create(:external_member) }
    let(:user) { create(:user) }
    let(:conversation) { create(:conversation) }

    context 'when all parameters are valid' do
      it 'creates a new message and returns success' do
        post :start_chat, params: {
          external_member_id: external_member.id,
          conversation_id: conversation.id,
          user_id: user.id,
          message: { body: 'Hello, this is a test message' }
        }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']['body']).to eq('Hello, this is a test message')
      end
    end
  

    context 'when external_member is not found' do
      let(:valid_params) do
        {
          conversation_id: conversation.id,
          user_id: user.id,
          external_member_id: nil
        }
      end
      it 'returns a not found error' do
        post :start_chat, params: valid_params.merge(external_member_id: nil), as: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Member not found')
      end
    end

    context 'when conversation is not found' do
      
      let(:valid_params) do
        {
          user_id: user.id,
          external_member_id: external_member.id # include other necessary params
        }
      end
      it 'returns a not found error' do
        post :start_chat, params: valid_params.merge(conversation_id: nil), as: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Conversation not found')
      end
    end

    context 'when user is not found' do
      let(:valid_params) do
        {
          conversation_id: conversation.id,
          # user_id: user.id,
          external_member_id: nil
        }
      end
      it 'returns a not found error' do
        post :start_chat, params: valid_params.merge(user_id: nil)

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Member not found')
      end
    end

    context 'when message fails to save' do
      let(:valid_params) do
        {
          conversation_id: conversation.id,
          user_id: user.id,
          external_member_id: nil
        }
      end
      before do
        allow_any_instance_of(Message).to receive(:save).and_return(false)
        allow_any_instance_of(Message).to receive_message_chain(:errors, :full_messages).and_return(['Some error'])
      end

      it 'returns an unprocessable entity error with error messages' do
        post :start_chat, params: valid_params

        expect(response).to have_http_status(404)
        json_response = JSON.parse(response.body)
        # expect(json_response['status']).to eq('error')
        # expect(json_response['errors']).to include('Some error')
      end
    end
  end

end
  

