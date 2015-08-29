class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_situations

  def show
    @user_profile = current_user.user_profile
  end

  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile

    result = @user_profile.update(user_profile_params)

    @situations.each do |situation|
      permitted_params = profile_image_params("profile_image_#{situation}".to_sym)
      ProfileImage.find_or_create_by(
        user_profile_id: permitted_params[:user_profile_id] ,
        situation: permitted_params[:situation]
      ).update(permitted_params)
    end

    if result
      flash[:notice] = I18n.t('user_profiles.update.flash_edited')
      redirect_to user_profile_path
    else
      render :edit
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:answer_name, :gender, :group_id, :project_id, :joined_year, :detail)
  end

  def profile_image_params (target)
    params.require(target).permit(:user_profile_id, :image, :situation)
  end

  def set_situations
    @situations = ProfileImage.situations
  end
end
