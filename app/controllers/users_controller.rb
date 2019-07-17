class UsersController < ApplicationController
  before_action :set_user, only: [:show, :attendances, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :set_one_month, only: [:show, :attendances]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(id: :desc).page(params[:page]).per(20)
  end

  def show
    @worked_sum = @attendances.where.not(clock_in: nil).map(&:work_on).uniq.count
  end

  def attendances
    @worked_sum = @attendances.where.not(clock_in: nil).map(&:work_on).uniq.count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Loged in successfully.'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Updated user info."
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "Deleted the user, #{@user.name}."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(
        :name,
        :img,
        :email, 
        :password, 
        :password_confirmation
      )
    end

end
