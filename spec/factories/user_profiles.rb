FactoryGirl.define do
  factory :user_profile do
    user { FactoryGirl.create :user }
    answer_name     { Forgery(:name).last_name }
    group_id        { FactoryGirl.create :project }
    project_id      { FactoryGirl.create :group }
    joined_year     { [Time.zone.now.year, Time.zone.now.year-1].sample }
    gender          { ['male', 'female'].sample }

    after(:create) do |user_profile|
      FactoryGirl.create :profile_image, user_profile_id: user_profile.id, situation: 'normal'
    end

    trait :with_answer do
      after(:create) do |user_profile|
        FactoryGirl.create_list :answer, 10, user_profile_id: user_profile.id, to_user_profile_id: UserProfile.all.sample.id
      end
    end

    trait :with_more_incorrect_answer do
      after(:create) do |user_profile|
        FactoryGirl.create_list :answer, 6, user_profile_id: user_profile.id, to_user_profile_id: UserProfile.all.sample.id, correct: false
        FactoryGirl.create_list :answer, 4, user_profile_id: user_profile.id, to_user_profile_id: UserProfile.all.sample.id, correct: true
      end
    end
  end
end
