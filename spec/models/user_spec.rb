require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  context 'associations' do
    it 'has many transactions' do
      should have_many(:transactions)
    end
  end
end
