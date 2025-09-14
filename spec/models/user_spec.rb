# frozen_string_literal: true

RSpec.describe User do
  subject(:object) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it 'has default role viewer' do
      expect(described_class.new.role).to eq('viewer')
    end

    it 'is invalid when role is not allowed' do
      object.role = 'invalid'
      expect(object).not_to be_valid
      expect(object.errors[:role]).to be_present
    end
  end

  describe 'enums' do
    it 'defines viewer and admin roles' do
      expect(described_class.roles).to eq('viewer' => 'viewer', 'admin' => 'admin')
    end

    it 'responds to role predicates' do
      expect(build(:user).viewer?).to be true
      expect(build(:user, :admin).admin?).to be true
    end
  end

  describe 'factories' do
    it 'creates valid default viewer' do
      expect(build(:user)).to be_valid
      expect(build(:user).viewer?).to be true
    end

    it 'creates valid admin user' do
      expect(build(:user, :admin)).to be_valid
      expect(build(:user, :admin).admin?).to be true
    end
  end
end
