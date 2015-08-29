class User < ActiveRecord::Base
  has_one :user_profile
  devise :database_authenticatable, :rememberable, :omniauthable

  def self.find_for_google_oauth2(auth)
    user = User.find_by(email: auth.info.email)

    unless user
      ActiveRecord::Base.transaction do
        user = User.create!(
          name:     auth.info.name,
          provider: auth.provider,
          uid:      auth.uid,
          email:    auth.info.email,
          token:    auth.credentials.token,
          password: Devise.friendly_token[0, 20]
        )
        UserProfile.create!(
          user_id: user.id,
        )
      end
    end
    user
  end
end
