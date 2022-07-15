# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Supervisor
  class ApplicationController < Administrate::ApplicationController
    before_action :basic_auth
    protect_from_forgery with: :exception
    before_action :login_required_as_admin

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    private

    def basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.application.credentials.dig(:basic_auth, :username) && password == Rails.application.credentials.dig(:basic_auth, :password)
      end
    end

    def login_required_as_admin
      redirect_to root_url unless session[:admin]
    end
  end
end
