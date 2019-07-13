class AttendancesController < ApplicationController
  before_action :set_user, only: [:create, :edit, :update, :destroy]
  before_action :set_attendance, only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:update]
  before_action :admin_or_correct_user, only: [:update]

  def create
    @attendance = Attendance.new(user_id: @user.id, work_on: Time.zone.today, clock_in: Time.current.change(sec: 0))
    if @attendance.save!
      flash[:info] = "Clock in at #{@attendance.clock_in.strftime("%y/%m/%d %H:%M:%S")} successful!"
    else
      flash[:danger] = "Clock in/out failed."
    end
    redirect_to user_attendances_path(@user)
  end

  def edit
  end

  def update
    if params['fix']
      if @attendance.update(attendance_params)
        flash[:info] = "Update successful!"
      else
        flash[:danger] = "Update failed"
      end
    elsif @attendance.clock_in.nil?
      if @attendance.update_attributes(clock_in: Time.current.change(sec: 0))
        flash[:info] = "Clock in at #{@attendance.clock_in.strftime("%y/%m/%d %H:%M:%S")} successful!"
      else
        flash[:danger] = "Clock in failed."
      end
    elsif @attendance.clock_out.nil?
      if @attendance.update_attributes(clock_out: Time.current.change(sec: 0))
        flash[:info] = "Clock out at #{@attendance.clock_out.strftime("%y/%m/%d %H:%M:%S")} successful!"
      else
        flash[:danger] = "Clock out failed."
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @attendance.destroy
    redirect_to user_attendances_path(@user)
  end

  private

    def attendance_params
      params.require(:attendance).permit(:clock_in, :clock_out, :note)
    end

    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def admin_or_correct_user
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "You are not allowed to edit."
        redirect_to(root_url)
      end  
    end

end
