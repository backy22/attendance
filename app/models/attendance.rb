class Attendance < ApplicationRecord
  belongs_to :user

  validates :work_on, presence: true
  validates :note, length: { maximum: 50 }

  validate :clock_out_is_invalid_without_clock_in
  validate :clock_out_before_clock_in_is_invalid

  validate :clock_time_should_be_unique

  def clock_out_is_invalid_without_clock_in
    errors.add(:clock_in, " is needed.") if clock_in.blank? && clock_out.present?
  end

  def clock_out_before_clock_in_is_invalid
    if clock_in.present? && clock_out.present?
      errors.add(:clock_in, " is earlier than clock_out") if clock_in > clock_out
    end
  end

  def clock_time_should_be_unique
    if clock_in.present? && clock_out.present?
      attendances = Attendance.where(work_on: self.work_on, user_id: self.user_id).where.not(clock_in: nil).where.not(clock_out: nil)
      attendances.each do |attendance|
        if clock_in < attendance.clock_out && clock_out > attendance.clock_in
          errors.add(:clock_in, "Invalid hours")
        end
      end
    end
  end
end
