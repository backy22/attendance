class Attendance < ApplicationRecord
  belongs_to :user

  validates :work_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:clock_in, "が必要です") if clock_in.blank? && clock_out.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    if clock_in.present? && clock_out.present?
      errors.add(:clock_in, "より早い退勤時間は無効です") if clock_in > clock_out
    end
  end
end
