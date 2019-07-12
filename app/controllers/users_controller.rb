class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :set_one_month, only: [:show, :edit_one_month]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
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

  def edit_one_month
  end

  def update_one_month
    @user.update_attributes(user_params)
    flash[:success] = "Update clock in/out in the whole month."
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "Data invalid. Update canceled"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  private

    def user_params
      params.require(:user).permit(
        :name, 
        :email, 
        :password, 
        :password_confirmation,
        attendances_attributes: [:id, :work_on, :user_id, :clock_in, :clock_out, :note, :_destroy]
      )
    end

end
