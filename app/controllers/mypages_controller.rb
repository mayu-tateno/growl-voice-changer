class MypagesController < ApplicationController
  before_action :require_login, only: %i[show edit]

  def show
    @pagy_voices, @voices = pagy(current_user.voices.order(created_at: :desc), page_param: :page_voices)
    @pagy_answers, @answers = pagy(current_user.answers.includes(:topic).order(created_at: :desc),
                                   page_param: :page_answers)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)

    if @user.update(user_params)
      redirect_to mypage_path, dark: (t 'defaults.message.updated', item: (t 'defaults.user_data'))
    else
      flash.now[:danger] = (t 'defaults.message.not_updated', item: (t 'defaults.user_data'))
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
