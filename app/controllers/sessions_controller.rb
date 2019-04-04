class SessionsController < ApplicationController

  def new

  end

  def destroy

    redirect_to root_path
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are now logged in as #{user.email}."
      user_redirect
    end
  end

  private

  def user_redirect
    if current_user.admin?
      redirect_to(root_path)
    elsif current_user.user?
      redirect_to(profile_path)
    elsif current_user.merchant?
      redirect_to(dashboard_path)
    end
  end
end