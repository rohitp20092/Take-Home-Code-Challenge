require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.create(:user)
      transaction = FactoryBot.build(:transaction, user: user)
      expect(transaction).to be_valid
    end

    it 'is not valid without a transaction_id' do
      transaction = FactoryBot.build(:transaction, transaction_id: nil)
      expect(transaction).to_not be_valid
      expect(transaction.errors[:transaction_id]).to include("ID can't be blank")
    end

    it 'is not valid with a duplicate transaction_id' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:transaction, transaction_id: 'unique_id', user: user)
      transaction = FactoryBot.build(:transaction, transaction_id: 'unique_id', user: user)
      expect(transaction).to_not be_valid
      expect(transaction.errors[:transaction_id]).to include("ID has already been taken")
    end

    it 'is not valid without points' do
      transaction = FactoryBot.build(:transaction, points: nil)
      expect(transaction).to_not be_valid
      expect(transaction.errors[:points]).to include("can't be blank")
    end

    it 'is not valid with non-integer points' do
      transaction = FactoryBot.build(:transaction, points: 'non_integer')
      expect(transaction).to_not be_valid
      expect(transaction.errors[:points]).to include("is not a number")
    end

    it 'is not valid without a status' do
      transaction = FactoryBot.build(:transaction, status: nil)
      expect(transaction).to_not be_valid
      expect(transaction.errors[:status]).to include("can't be blank")
    end

    it 'is not valid without a user' do
      transaction = FactoryBot.build(:transaction, user: nil)
      expect(transaction).to_not be_valid
      expect(transaction.errors[:user]).to include("must exist")
    end
  end

  context 'associations' do
    it 'belongs to user' do
      should belong_to(:user)
    end
  end
end
