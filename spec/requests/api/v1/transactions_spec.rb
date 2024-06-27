require 'rails_helper'

RSpec.describe 'Api::V1::Transactions', type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe 'POST /api/v1/transactions/single' do
    let(:valid_attributes) { { transaction: { transaction_id: '999984', points: 100, user_id: @user.id, status: 'completed' } } }
    let(:invalid_attributes) { { transaction: { transaction_id: '', points: 100, user_id: @user.id, status: 'completed' } } }

    context 'with valid attributes' do
      it 'creates a new Transaction' do
        expect {
          post '/api/v1/transactions/single', params: valid_attributes
        }.to change(Transaction, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/transactions/single', params: valid_attributes
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['transaction_id']).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new Transaction' do
        expect {
          post '/api/v1/transactions/single', params: invalid_attributes
        }.to_not change(Transaction, :count)
      end

      it 'returns an error response' do
        post '/api/v1/transactions/single', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['errors']).to include("Transaction ID can't be blank")
      end
    end
  end
end
