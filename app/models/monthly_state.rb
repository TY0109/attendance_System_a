class MonthlyState < ApplicationRecord
  belongs_to :user

  validate :submit_without_request_instructor_is_invalid, on: :submit_monthly_state

  enum instructor_reply: { approval: 0, denial: 1 }

  def submit_without_request_instructor_is_invalid
    errors.add(:request_instructor, "が必要です") if request_instructor.blank? 
  end
end
