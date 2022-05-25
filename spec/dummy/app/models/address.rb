
# frozen_string_literal: true

class Address < ApplicationRecord
    belongs_to :user

    validates :city, length: { minimum: 3 }
end