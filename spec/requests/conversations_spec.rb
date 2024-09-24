require 'rails_helper'
RSpec.describe Api::ConversationsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let(:valid_attributes) { { sender_id: user1.id, recipient_id: user2.id, content: 'Hello' } }
  let(:invalid_attributes) { { sender_id: nil, recipient_id: nil, content: nil } }
  

  describe 'POST #create' do
    context 'when the conversation already exists' do
      let!(:existing_conversation) { Conversation.create!(sender_id: user1.id, recipient_id: user2.id) }

      it 'retrieves the existing conversation' do
        expect {
          post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        }.to change(Conversation, :count).by(0)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(existing_conversation.id)
      end
    end

    context 'when the conversation does not exist' do
      it 'creates a new conversation' do
        expect {
          post :create, params: { conversation: valid_attributes }
        }.to change(Conversation, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['content']).to eq(nil)
      end
    end

    context 'when the conversation creation fails due to invalid attributes' do
      it 'does not create a new conversation and returns errors' do
        expect {
          post :create, params: { conversation: invalid_attributes }
        }.to change(Conversation, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        
      end
    end
  end

  describe 'GET #index' do
    context 'without sort parameter' do
      it 'returns all conversations' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(0)
      end
    end

    context 'with sort parameter as asc' do
      it 'returns conversations sorted by sender name in ascending order' do
        get :index, params: { sort: 'asc' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with sort parameter as desc' do
      it 'returns conversations sorted by sender name in descending order' do
        get :index, params: { sort: 'desc' }
        expect(response).to have_http_status(:ok)

      end
    end
  end 
  def json_response
    JSON.parse(response.body)
  end


  describe 'GET #show' do
  let(:conversation) { create(:conversation, body: "Sample content") } 

  it 'returns a successful response' do
    get :show, params: { id: conversation.id }
    expect(response).to have_http_status(:success)
  end

  it 'returns the correct conversation in JSON format' do
    get :show, params: { id: conversation.id }
    json_response = JSON.parse(response.body)

    expect(json_response['id']).to eq(conversation.id)
    expect(json_response['body']).to eq(conversation.body) 
  end

  it 'returns a 404 status if the conversation does not exist' do
    get :show, params: { id: 99999 } 
    expect(response).to have_http_status(:not_found)
  end
  end
end 
