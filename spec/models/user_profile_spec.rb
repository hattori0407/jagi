require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  it { should have_many(:profile_images) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it { should validate_length_of(:answer_name).is_at_most(30) }
  it { should validate_numericality_of(:group_id) }
  it { should validate_numericality_of(:joined_year) }
  it { should validate_length_of(:detail).is_at_most(10000) }
end
