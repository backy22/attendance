class AttendancesController < ApplicationController
  before_action :set_user, only: [:create, :update, :edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "Clock in/out failed."

  def create
    @attendance = Attendance.new(user_id: @user.id, work_on: Date.today, clock_in: Time.current.change(sec: 0))
    if @attendance.save!
      flash[:info] = "Clock in successful!"
    else
      flash[:danger] = UPDATE_ERROR_MSG
    end
    redirect_to @user
  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.clock_in.nil?
      if @attendance.update_attributes(clock_in: Time.current.change(sec: 0))
        flash[:info] = "Clock in successful!"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.clock_out.nil?
      if @attendance.update_attributes(clock_out: Time.current.change(sec: 0))
        flash[:info] = "Clock out successful!"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "Update clock in/out in the whole month."
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "Data invalid. Update canceled"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  private

    def attendances_params
      params.require(:user).permit(attendances: [:clock_in, :clock_out, :note])[:attendances]
    end

    # admin or login user
    def admin_or_correct_user
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "You are not allowed to edit."
        redirect_to(root_url)
      end  
    end
end
