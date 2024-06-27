require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_attributes) { { user: { name: 'Test User' } } }
    let(:invalid_attributes) { { user: { name: nil } } }

    context 'with valid attributes' do
      it 'creates a new User' do
        expect {
          post '/api/v1/users', params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/users', params: valid_attributes
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['user_id']).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new User' do
        expect {
          post '/api/v1/users', params: invalid_attributes
        }.to_not change(User, :count)
      end

      it 'returns an error response' do
        post '/api/v1/users', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to include("Name can't be blank")
      end
    end
  end
end
