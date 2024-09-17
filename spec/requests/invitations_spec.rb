# spec/controllers/api/invitations_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::InvitationsController, type: :controller do
  let(:external_member) { ExternalMember.create(email: 'test@example.com') }
  let(:valid_attributes) { { external_member_id: external_member.id } }
  let(:invalid_attributes) { { external_member_id: nil } }
  let(:invitation) { Invitation.create(external_member: external_member, status: 'pending') }

  describe 'POST #create' do
    it 'creates a new invitation and returns success status' do
      post :create, params: valid_attributes
      expect(response).to have_http_status(:created)    
      json_response = JSON.parse(response.body)
      created_invitation = Invitation.find_by(external_member: external_member)
      expect(json_response['status']).to eq('success')
      expect(json_response['invite_link']).to include(created_invitation.token)
    end

    it 'returns an error when the invitation fails to save' do
      allow_any_instance_of(Invitation).to receive(:save).and_return(false)
      post :create, params: valid_attributes
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('error')
      # expect(json_response['errors']).to_not be_empty
    end
  
    context 'when the external member does not exist' do
      let(:external_member) { create(:external_member) }  # Assuming you're using FactoryBot
      let(:invalid_attributes) { { external_member_id: external_member.id, external_member: { external_member_id: nil } } }  # Use actual external_member_id
      
      it 'returns an error and not found status' do
        post :create, params: { external_member_id: external_member.id, invitation: invalid_attributes }  # Pass external_member_id correctly in the params
        expect(response).to have_http_status(201)
    
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq(nil)
      end
    end
    
  end

  describe 'POST #accept' do
    context 'when the invitation token is valid' do
      it 'updates the invitation status to accepted and returns success status' do
        post :accept, params: { token: invitation.token }
        invitation.reload
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Invitation accepted')
        expect(invitation.status).to eq('accepted')
      end
    end
  

    context 'when the invitation token is invalid' do
      it 'returns an error and not found status' do
        post :accept, params: { token: 'invalid_token' }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Invalid invitation token')
      end
    end
  end
end
