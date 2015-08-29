require 'rails_helper'

feature 'トップページ', type: :feature do
  context 'ログインしている時' do
    include_context 'login_as_user'

    scenario 'ログインユーザのプロフィール画面にリダイレクト' do
      visit root_path
      expect(current_path).to eq user_profile_path
    end
  end

  context 'ログインしていない時' do
    scenario 'サインイン画面にリダイレクト' do
      visit root_path
      expect(current_path).to eq new_user_session_path
    end
  end
end
