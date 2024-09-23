require 'rails_helper'

RSpec.describe Api::ConversationsController, type: :controller do
  describe "GET #index" do
    let!(:user1) { create(:user, name: 'Alice') }
    let!(:user2) { create(:user, name: 'Bob') }
    let!(:user3) { create(:user, name: 'Charlie') }
    let!(:conversation1) { create(:conversation, sender: user1, recipient: user2) }
    let!(:conversation2) { create(:conversation, sender: user3, recipient: user1) }

    context "without sorting" do
      it "returns all conversations in JSON format" do
        get :index
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response[0]["sender"]["name"]).to eq(user1.name)
        expect(json_response[0]["recipient"]["name"]).to eq(user2.name)
      end
    end

    context "with sorting by sender's name ascending" do
      it "returns conversations sorted by sender's name in ascending order" do
        get :index, params: { sort: 'asc' }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response[0]["sender"]["name"]).to eq('Alice')
        expect(json_response[1]["sender"]["name"]).to eq('Charlie')
      end
    end

    context "with sorting by sender's name descending" do
      it "returns conversations sorted by sender's name in descending order" do
        get :index, params: { sort: 'desc' }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response[0]["sender"]["name"]).to eq('Charlie')
        expect(json_response[1]["sender"]["name"]).to eq('Alice')
      end
    end
  end
end
