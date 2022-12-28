# frozen_string_literal: true

FactoryBot.define do
  factory :users_admin, class: "Users::Admin" do
    is_admin { true }
    association(:user, factory: :user)
  end
end
