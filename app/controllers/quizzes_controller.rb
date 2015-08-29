class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_quiz_started, except: [:new, :create]
  before_action :require_quiz_not_started, only: [:new, :create]

  def new
  end

  def create
    session[:current_quiz] = Quiz.new(user_id: current_user.id, conditions: condition_params)
    redirect_to question_quiz_path
  end

  def destroy
    session.delete(:current_quiz)
    redirect_to new_quiz_path
  end

  def question
    @current_quiz = Quiz.new(session[:current_quiz].with_indifferent_access)
    @question     = @current_quiz.next_question
  end

  def answer
    @current_quiz = Quiz.new(session[:current_quiz].with_indifferent_access)
    @current_quiz.answer!(params[:answer_name])
    session[:current_quiz] = @current_quiz
    redirect_to result_quiz_path
  end

  def result
    @current_quiz = Quiz.new(session[:current_quiz].with_indifferent_access)
    @question     = @current_quiz.last_question
    @result       = @current_quiz.last_result
  end

  private

  def condition_params
    params.permit(:group_id, :project_id, :joined_year)
  end

  def require_quiz_started
    redirect_to new_quiz_path if session[:current_quiz].blank?
  end

  def require_quiz_not_started
    redirect_to question_quiz_path if session[:current_quiz].present?
  end
end
