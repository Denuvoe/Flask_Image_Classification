FactoryBot.define do
    factory :address do
      city { "Phoenix" }
      association :user, factory: :user
    end
  end
