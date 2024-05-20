class Attendance < ApplicationRecord
  belongs_to :user
 
  validates :worked_on, presence:true
  validates :note, length: { maximum: 50 }
  
  validate :finished_at_is_invalid_without_a_started_at
  validate :started_at_than_finished_at_fast_is_invalid

  # 1か月の勤怠編集申請時、出勤時間のみでの修正を防止
  # bulk_submitメソッドに限定しないと、updateにも適用されて、打刻ができなくなる
  validate :started_at_is_invalid_without_a_finished_at, on: :bulk_submit

  # 残業申請時、情報なしでの申請を防止
  validate :ovetime_submit_without_overtime_info_is_invalid, on: :submit

  # 変更にチエックなしでの承認/否認を防止
  validate :approve_without_change_is_invalid, on: :change_overtime_state
  validate :approve_without_change_one_month_is_invalid, on: :change_correction_state
  validate :approve_without_change_comp_is_invalid, on: :change_monthly_state

  enum instructor_reply: { approval: 0, denial: 1 }
  # TODO: approvemnetという英単語は存在しないので変更必要(approvalは使用済みなので不可)
  enum instructor_one_month_reply: { approvement: 0, deniment: 1 }
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at,"が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_is_invalid
    if started_at.present? && finished_at.present? && !tomorrow_one_month? && instructor_one_month_test.present?     #上司が入力されていないと時は、申請にならないので、出>退でも構わない#
      errors.add(:started_at, "より早い時間は無効です。") if started_at > finished_at
    end
  end

  def started_at_is_invalid_without_a_finished_at
    errors.add(:finished_at,"が必要です") if started_at.present? && finished_at.blank?
  end

  def ovetime_submit_without_overtime_info_is_invalid
    %i[scheduled_end_time business_outline instructor_test].each do |attr|
      errors.add(attr, "が必要です") if send(attr).blank?
    end
  end
  
  # TODO: 以下3つ冗長なので修正
  def approve_without_change_is_invalid
    errors.add(:change, "が必要です") if change.blank?
  end

  def approve_without_change_one_month_is_invalid
    errors.add(:change_one_month, "が必要です") if change_one_month.blank?
  end

  def approve_without_change_comp_is_invalid
    errors.add(:change_comp, "が必要です") if change_comp.blank?
  end
end
