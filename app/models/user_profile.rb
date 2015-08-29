class UserProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :group
  has_many :profile_images

  delegate :name, to: :user

  validates :user_id, presence: true, numericality: true, uniqueness: true
  validates :answer_name, allow_nil: true, length: { maximum: 30 }
  validates :group_id, allow_nil: true, numericality: true
  validates :project_id, allow_nil: true, numericality: true
  validates :gender, allow_nil: true, inclusion: { in: ['', 'male', 'female'] }
  validates :joined_year, allow_nil: true, numericality: true
  validates :detail, allow_nil: true, length: { maximum: 10000 }

  scope :without_user, -> (user_id) {
    where.not(user_id: user_id)
  }
  scope :without_pending, -> {
    joins(:profile_images).merge(ProfileImage.without_pending)
  }
  scope :with_group, -> (group_id) {
    where(group_id: group_id) if group_id.present?
  }
  scope :with_project, -> (project_id) {
    where(project_id: project_id) if project_id.present?
  }
  scope :with_gender, -> (gender) {
    where(gender: gender) if gender.present?
  }
  scope :with_joined_year, -> (joined_year) {
    where(joined_year: joined_year) if joined_year.present?
  }
  # TODO: with_review_modeを実装

  def profile_image_url(situation)
    profile_image(situation).image.url
  end

  private

  def profile_image(situation)
    profile_images.find_by(situation: situation) || profile_images.find_by(situation: :normal)
  end
end

