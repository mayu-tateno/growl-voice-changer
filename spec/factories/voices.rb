FactoryBot.define do
  factory :voice do
    user { nil }
    growl_voice { "MyString" }
    description { "MyString" }
    status { 1 }
  end
end
