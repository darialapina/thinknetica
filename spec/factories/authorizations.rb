FactoryGirl.define do
  factory :authorization do
    user
    provider "Facebook"
    uid "1536489356396528"
  end
end
