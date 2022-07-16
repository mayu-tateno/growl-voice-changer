module Supervisor
  class SessionsController < ApplicationController
    skip_before_action :login_required_as_admin

    def new; end

    def create
      if params[:name] == Rails.application.credentials.dig(:admin, :name) &&
         params[:password] == Rails.application.credentials.dig(:admin, :password)
        session[:admin] = Rails.application.credentials.dig(:admin, :name)
        redirect_to supervisor_users_path
      else
        render :new
      end
    end

    def logout
      reset_session
      redirect_to root_url
    end
  end
end
