FactoryBot.define do
  factory :answer do
    user { nil }
    topic { nil }
    growl_voice { "MyString" }
    description { "MyString" }
  end
end
