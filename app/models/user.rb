# frozen_string_literal: true

require 'securerandom'

class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, :password_confirmation
  has_secure_password

  before_create do |user|
    user.api_key = user.create_api_key
  end

  def create_api_key
    loop do
      key = SecureRandom.hex
      break key unless User.exists?(api_key: key)
    end
  end
end
