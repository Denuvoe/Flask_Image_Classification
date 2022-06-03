# frozen_string_literal: true

class User < ApplicationRecord
  has_one :users_admin, class_name: "Users::Admin"

  validates :first_name, length: { minimum: 3 }
end
