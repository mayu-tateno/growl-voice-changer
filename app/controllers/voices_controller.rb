class VoicesController < ApplicationController
  before_action :set_voice, only: %[show]

  def new; end

  def show; end

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
      voice = guest_user.voices.build(voice_params)
    end

    if voice.save
      render json: { url: voice_path(voice) }
    else
      render json: { url: new_voice_path }
    end
  end

  private

  def set_voice
    @voice = Voice.find(params[:id])
  end

  def voice_params
    params.permit(:growl_voice, :description)
  end
end
