# spec/controllers/api/authentications_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::AuthenticationsController, type: :controller do

  let(:user) { FactoryBot.create(:user) } 
  
  let(:valid_params) do
    {
      user: {
        email: 'testuser@example.com',
        password: 'password',
        password_confirmation: 'password',
        first_name: 'First',
        last_name: 'Last',
        company: 'Company'
      }
    }
  end

  let(:login_params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST #sign_up' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :sign_up, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns a token and user information' do
        post :sign_up, params: valid_params
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response).to have_key('token')
        expect(json_response['user']['email']).to eq('testuser@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        invalid_params = valid_params.merge(user: { email: nil })
        expect {
          post :sign_up, params: invalid_params
        }.not_to change(User, :count)
      end

      it 'returns an error message' do
        post :sign_up, params: { user: { email: nil, password: 'password' } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include("Email can't be blank")
      end
    end
  end

  describe 'POST #login' do
    context 'with valid credentials' do
      it 'returns a token and user information' do
        post :login, params: login_params
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('accessToken')
        expect(json_response['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized error' do
        post :login, params: { email: user.email, password: 'wrongpassword' }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Unauthorized')
      end
    end
  end
end
