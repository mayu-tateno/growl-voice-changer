class OauthsController < ApplicationController
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      redirect_to root_path, dark: "#{provider.titleize}でログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, dark: "#{provider.titleize}でログインしました"
      rescue StandardError
        redirect_to root_path, danger: "#{provider.titleize}でのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
