class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:index, :new, :create]

  def index
    @users = User.activated.paginate page: params[:page],
    per_page: Settings.per_page
  end

  def show
    redirect_to root_url && return unless User.where(activated: true)
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users_controller.check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users_controller.profile_up"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "controllers.users_controller.delete"
    redirect_to users_url
  end

  def following
    @title = t "controllers.users_controller.following"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.per_page
    render :show_follow
  end

  def followers
    @title = t "controllers.users_controller.followers"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.per_page
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users_controller.user_not_exist"
    redirect_to home_path
  end
end
