class ProfileImage < ActiveRecord::Base
  belongs_to :user_profile

  validates :user_profile_id, presence: true, numericality: true
  validates :image, presence: true
  validates :situation, presence: true

  mount_uploader :image, ImageUploader

  scope :without_pending, -> {
    where.not(situation: nil)
  }
  scope :with_situation, ->(situation) {
    where(situation: situation)
  }

  def self.situations
    [:normal, :correct, :incorrect]
  end
end

