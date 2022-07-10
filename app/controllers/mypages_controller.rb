class MypagesController < ApplicationController
  before_action :require_login, only: %i[show]

  def show
    @pagy_voices, @voices = pagy(current_user.voices.order(created_at: :desc), page_param: :page_voices)
    @pagy_answers, @answers = pagy(current_user.answers.includes(:topic).order(created_at: :desc), page_param: :page_answers)
  end
end
