shared_context 'login_as_user' do
  include_context 'setup_OmniAuth_config', :google_oauth2
  let!(:login_user) { FactoryGirl.create :user, :with_user_profile, email: oauth_user.info.email }
  before { visit user_omniauth_authorize_path(provider: :google_oauth2) }
end
