# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :password_confirmation }
    it { should validate_uniqueness_of :email }
    it { should have_secure_password }

    it 'has password digest' do
      user = User.create(email: 'b@g', password: 'test', password_confirmation: 'test')
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('test')
    end
  end

  describe 'instance methods' do
    it 'creates api key' do
      user = User.create(email: 'e@g', password: 'test', password_confirmation: 'test')
      expect(user.api_key).to_not be_nil
      expect(user.api_key).to be_a(String)
      expect(user.api_key.length).to eq(32)
    end
  end
end
