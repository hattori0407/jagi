require 'rails_helper'

feature 'セッション' do
  feature 'ログイン' do
    include_context 'setup_OmniAuth_config', :google_oauth2

    scenario 'ログインする' do
      visit new_user_session_path
      click_on I18n.t('pages.index.please_login_with_google')

      expect(page.current_path).to eq user_profile_path
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
    end
  end

  feature 'ログアウト' do
    include_context 'login_as_user'

    scenario 'ログアウトする' do
      visit user_profile_path
      click_on 'logout'

      expect(page.current_path).to eq new_user_session_path
      expect(page).to have_content I18n.t('devise.sessions.user.signed_out')
    end
  end
end
