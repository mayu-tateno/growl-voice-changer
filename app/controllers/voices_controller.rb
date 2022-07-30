class VoicesController < ApplicationController
  before_action :set_voice, only: %i[show]

  def new; end

  def show; end

  def index
    @pagy, @voices = pagy(Voice.where(status: :open).includes(:user).order(created_at: :desc))
  end

  def create
    if logged_in?
      voice = current_user.voices.build(voice_params)
    else
      random_value = SecureRandom.hex
      guest_user = User.create!(
        name: 'ゲストユーザー',
        email: "guest_#{random_value}@example.com",
        password: random_value,
        password_confirmation: random_value,
        role: :guest
      )
      voice = guest_user.voices.build(voice_params.merge(status: :closed))
    end

    if voice.save
      render json: { url: voice_path(voice), result: 'success' }
    else
      render json: { url: new_voice_path, result: 'failed' }
    end
  end

  def edit
    @voice = current_user.voices.find(params[:id])
  end

  def update
    @voice = current_user.voices.find(params[:id])
    if @voice.update(voice_params_for_update)
      redirect_to @voice, dark: t('defaults.message.updated', item: Voice.human_attribute_name(:description))
    else
      flash.now[:danger] = t('defaults.message.not_updated', item: Voice.human_attribute_name(:description))
      render :edit
    end
  end

  def destroy
    voice = current_user.voices.find(params[:id])
    voice.destroy!
    redirect_to voices_path, dark: t('defaults.message.deleted', item: Voice.model_name.human)
  end

  private

  def set_voice
    @voice = Voice.find(params[:id])
  end

  def voice_params
    params.permit(:growl_voice, :description)
  end

  def voice_params_for_update
    params.require(:voice).permit(:description)
  end
end
