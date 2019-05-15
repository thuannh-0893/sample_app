class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user &. authenticate(params[:session][:password])
      check_activation @user
    else
      flash.now[:danger] = t "controllers.sessions_controller.error"
      render :new
    end
  end

  def check_activation user
    if user.activated?
      log_in user
      check_remember_me user
      redirect_back_or user
    else
      message = t "controllers.sessions_controller.message_fail1"
      message += t "controllers.sessions_controller.message_fail2"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def check_remember_me user
    return remember user if params[:session][:remember_me] == Settings.remember
    forget user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
