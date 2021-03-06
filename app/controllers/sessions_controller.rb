class SessionsController < ApplicationController

  def new
    if current_user
      flash[:error] = 'You are already logged in'
      user_redirect()
    end
  end

  def destroy
    session.clear
    flash[:alert] = 'You are now logged out'
    redirect_to root_path
  end

  def create
    user = User.find_by(email: params[:email])
    # statement to prevent users that dont exist or are diabled from logging in
    if !user || !user.enabled
      flash[:error] = 'Your credentials are incorrect.'
      render :new
    elsif user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are now logged in as #{user.name}."
      user_redirect()
    else
      flash[:error] = 'Your credentials are incorrect.'
      render :new
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
