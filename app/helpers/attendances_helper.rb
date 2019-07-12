module AttendancesHelper

  def rowspan(attendances)
    unless attendances.map(&:clock_in).push(attendances.map(&:clock_out)).flatten.include?(nil)
      return attendances.size + 1
    else
      return attendances.size
    end
  end
  
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.work_on
      return 'In' if attendance.clock_in.nil?
      return 'Out' if attendance.clock_in.present? && attendance.clock_out.nil?
    end
    return false
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
end
