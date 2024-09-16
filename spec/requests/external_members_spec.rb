require 'rails_helper'

RSpec.describe Api::ExternalMembersController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { attributes_for(:external_member) }
      it 'creates a new ExternalMember' do
        expect {
          post :create, params: { external_member: valid_attributes }
        }.to change(ExternalMember, :count).by(1)
      end

      it 'renders the created external member as JSON' do
        post :create, params: { external_member: valid_attributes }
        expect(response).to have_http_status(:created)

        
        response_json = JSON.parse(response.body)

       
        expect(response_json['name']).to eq(valid_attributes[:name])
        expect(response_json['email']).to eq(valid_attributes[:email])
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { name: nil, email: 'invalid_email' } }

      it 'does not create a new ExternalMember' do
        expect {
          post :create, params: { external_member: invalid_attributes }
        }.to_not change(ExternalMember, :count)
      end

      it 'renders errors as JSON' do
        post :create, params: { external_member: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(json_response['errors']).to be_an_instance_of(Array)
        expect(json_response['errors']).to include('Email is invalid') 
      end
    end
  end

  describe 'GET #index' do
    let!(:external_members) { create_list(:external_member, 3) }

    it 'returns a list of external members' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(external_members.as_json(only: [:id, :name, :email]))
    end
  end

  describe 'GET #show' do
    let(:external_member) { create(:external_member) }

    it 'returns the requested external member' do
      get :show, params: { id: external_member.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(external_member.as_json(only: [:id, :name, :email]))
    end

    context 'when the external member does not exist' do
      it 'returns a 404 not found status' do
        get :show, params: { id: 'nonexistent_id' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end



  describe 'PATCH #update' do
    let(:external_member) { create(:external_member) }
    let(:new_attributes) { { name: 'Jane Doe', email: 'jane.doe@example.com' } }

    it 'updates the requested external member' do
      patch :update, params: { id: external_member.id, external_member: new_attributes }
      external_member.reload
      expect(external_member.name).to eq('Jane Doe')
      expect(external_member.email).to eq('jane.doe@example.com')
    end

    it 'renders the updated external member as JSON' do
      patch :update, params: { id: external_member.id, external_member: new_attributes }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(new_attributes)
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { name: nil, email: 'invalid_email' } }

      it 'does not update the external member' do
        patch :update, params: { id: external_member.id, external_member: invalid_attributes }
        external_member.reload
        expect(external_member.name).to_not eq('Jane Doe')
        expect(external_member.email).to_not eq('invalid_email')
      end

      it 'renders the errors as JSON' do
        patch :update, params: { id: external_member.id, external_member: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response).to include( 'email' => ["is invalid"])
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:external_member) { create(:external_member) }

    it 'destroys the requested external member' do
      expect {
        delete :destroy, params: { id: external_member.id }
      }.to change(ExternalMember, :count).by(-1)
    end

    it 'returns no content status' do
      delete :destroy, params: { id: external_member.id }
      expect(response).to have_http_status(:no_content)
    end
  end

end


