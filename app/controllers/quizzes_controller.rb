
class QuizzesController < ApplicationController
  def show
    @answer_user_profile = UserProfile.answer_user(params, current_user.user_profile)

    @total_correct = current_user.user_profile.total_correct
    @total_incorrect = current_user.user_profile.total_incorrect

    @profile_image_normal = ProfileImage.find_by(user_profile_id: @answer_user_profile.id, situation: 'normal') if @answer_user_profile.present?
  end

  def answer
    @answer_user_profile = UserProfile.find(params[:answer_user_id])

    if Quiz.correct? params[:answer_user_name], @answer_user_profile
      create_answer_history(true, params[:answer_user_name], current_user.user_profile.id, params[:answer_user_id])

      flash[:image_url] = @answer_user_profile.find_image_url('correct')
      flash[:notice] = I18n.t("quiz.show.correct_result")
    else
      create_answer_history(false, params[:answer_user_name], current_user.user_profile.id, params[:answer_user_id])

      flash[:image_url] = @answer_user_profile.find_image_url('incorrect')
      flash[:notice] = I18n.t("quiz.show.incorrect_result")
    end

    flash[:name] = @answer_user_profile.name
    flash[:answer_name] = @answer_user_profile.answer_name if @answer_user_profile.answer_name.present?
    flash[:project] = @answer_user_profile.project.name if @answer_user_profile.project.present?
    flash[:group] = @answer_user_profile.group.name if @answer_user_profile.group.present?
    flash[:joined_year] = @answer_user_profile.joined_year if @answer_user_profile.joined_year.present?
    flash[:detail] = @answer_user_profile.detail if @answer_user_profile.detail.present?

    redirect_to quiz_path(params.permit(:joined_year, :group_id, :project_id, :review_mode, :joined_year) )
  end

  private

  def create_answer_history(correct, answer, user_profile_id, to_user_profile_id)
    Answer.create!(correct: correct, answer: answer, user_profile_id: user_profile_id, to_user_profile_id: to_user_profile_id)
  end
end
