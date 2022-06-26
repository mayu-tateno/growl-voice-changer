class VoicesController < ApplicationController
  def new; end

  def create
    voice = current_user.voices.build(voice_params) if logged_in?

    if voice.save
      render json: { url: root_url }
    else
      render json: { url: new_voice_path }
    end
  end

  private

  def voice_params
    params.permit(:growl_voice, :description)
  end
end
