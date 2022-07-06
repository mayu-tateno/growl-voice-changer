class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger, :light, :dark, :secondary
  include Pagy::Backend

  def not_authenticated
    redirect_to login_url, danger: t('defaults.message.please_login')
  end
end
