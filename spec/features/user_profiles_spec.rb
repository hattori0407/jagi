require 'rails_helper'

# TODO: ログイン必須の確認
# TODO: genderのもち方がダサイ
feature 'ユーザプロフィール', type: :feature do
  include_context 'login_as_user'

  feature 'プロフィール表示' do
    scenario 'プロフィールが表示できる' do
      visit user_profile_path

      expect(page).to have_content login_user.name
      expect(page).to have_content login_user.provider
      expect(page).to have_content login_user.uid
      expect(page).to have_content login_user.email
    end
  end

  feature 'プロフィール編集' do
    include_context 'login_as_user'

    let!(:projects) { FactoryGirl.create_list :project, 5 }
    let!(:groups)   { FactoryGirl.create_list :group, 5 }

    let(:new_answer_name) { Forgery(:name).full_name }
    let(:new_joined_year) { "#{Time.zone.now.year}#{I18n.t('user_profiles.edit.year')}" }
    let(:new_project)     { projects.sample.name }
    let(:new_group)       { groups.sample.name }
    let(:new_gender)      { I18n.t('user_profiles.edit.male') }
    let(:new_detail)      { Forgery(:basic).text }

    before do
      visit edit_user_profile_path
    end

    scenario 'プロフィールが編集できる' do
      fill_in 'user_profile_answer_name', with: new_answer_name
      select new_gender, from: 'user_profile_gender'
      select new_joined_year, from: 'user_profile_joined_year'
      select new_group, from: 'user_profile_group_id'
      select new_project, from: 'user_profile_project_id'
      fill_in 'user_profile_detail', with: new_detail
      click_on I18n.t('helpers.submit.update')

      expect(current_path).to eq user_profile_path
      expect(page).to have_content new_answer_name
      expect(page).to have_content new_joined_year
      expect(page).to have_content new_gender
      expect(page).to have_content new_project
      expect(page).to have_content new_group
      expect(page).to have_content new_detail
      expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
    end

    # context '画像が添付された場合' do
    #   after do
    #     ProfileImage.situations.each do |situation|
    #       profile_image = ProfileImage.find_by(user_profile_id: login_user.user_profile.id, situation: situation)
    #       profile_image.remove_image!
    #       profile_image.save
    #     end
    #   end

    #   scenario '画像がアップロード・リサイズできる' do
    #     ProfileImage.situations.each do |situation|
    #       attach_file "profile_image_#{situation}_image", "fixtures/files/for_upload.jpg"
    #     end

    #     click_on I18n.t('helpers.submit.update')

    #     ProfileImage.situations.each do |situation|
    #       profile_image = ProfileImage.find_by(user_profile_id: login_user.user_profile.id, situation: situation)

    #       expect(profile_image).to be_truthy
    #       expect(page).to have_css("img[src='#{profile_image.image.url}']")

    #       file_exists = File.exists? ("public#{profile_image.image.url}")
    #       expect(file_exists).to be_truthy
    #     end
    #   end
    # end
  end
end
