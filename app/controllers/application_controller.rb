class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  $days_of_the_week = %w{Sun Mon Tue Wed Thu Fri Sat}

  def set_user
    if (params[:user_id])
      @user = User.find(params[:user_id])
    else
      @user = User.find(params[:id])
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please login."
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def set_one_month 
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    @attendances = @user.attendances.where(work_on: @first_day..@last_day).order(:work_on)

    unless @attendances.present?
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(work_on: day) }
      end
    @attendances = @user.attendances.where(work_on: @first_day..@last_day).order(:work_on)
    end

  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "Unable to read the data. Please reload the page."
    redirect_to root_url
  end
end
