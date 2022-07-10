class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to root_url, dark: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
  end

  def destroy
    if current_user.destroy
      redirect_to root_url, dark: t('.success')
    else
      redirect_to root_url, danger: t('.failed')
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
