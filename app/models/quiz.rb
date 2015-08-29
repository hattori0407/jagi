class Quiz
  attr_accessor :total, :correct, :incorrect

  def initialize(params)
    @user_id    = params[:user_id]
    @conditions = params[:conditions]
    @questions  = params[:questions] || questions
    @answers    = params[:answers] || []
    @total      = 0
    @correct    = 0
    @incorrect  = 0
  end

  def next_question
    UserProfile.find_by(user_id: @questions[@answers.count])
  end

  def last_question
    UserProfile.find_by(user_id: @questions[@answers.count - 1])
  end

  def last_result
    (last_question.answer_name == @answers.last) ? :win : :lose
  end

  def fin?
    @questions.count == @questions.answers.count
  end

  def answer!(answer_name)
    @answers << answer_name
    increment_result
  end

  private

  def increment_result
    if last_result == :win
      @correct   += 1
    else
      @incorrect += 1
    end
    @total += 1
  end

  def questions
    UserProfile.
      without_user(@conditions[:user_id]).
      without_pending.
      with_group(@conditions[:group_id]).
      with_project(@conditions[:project_id]).
      with_gender(@conditions[:gender]).
      with_joined_year(@conditions[:joined_year]).
      pluck(:user_id)
  end
end
