class MypagesController < ApplicationController
  before_action :require_login, only: %i[show]

  def show
    @pagy, @voices = pagy(current_user.voices)
    @answers = current_user.answers
  end
end
