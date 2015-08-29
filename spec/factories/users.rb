FactoryGirl.define do
  factory :user do
    name      { Forgery(:name).full_name }
    provider  { :google_oauth2 }
    uid       { Forgery(:basic).number }
    email     { Forgery(:email).address }
    token     { Forgery(:basic).encrypt }
    password  { Devise.friendly_token[0, 20] }

    trait :with_user_profile do
      after(:create) do |user|
        FactoryGirl.create :user_profile, user_id: user.id
      end
    end
  end
end
