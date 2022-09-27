# frozen_string_literal: true

require 'securerandom'

class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, :password_confirmation
  has_secure_password
  has_secure_token :api_key
end
