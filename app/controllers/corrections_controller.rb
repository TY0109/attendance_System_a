class CorrectionsController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :correct_general_user
  before_action :set_one_month, only:[:apply]
  # １か月の勤怠編集を申請するページ
  def apply
    @superior = User.where(superior:true).where.not(id: @user.id)
  end
  
  # １か月の勤怠編集の申請が送信される
  def bulk_submit
    ActiveRecord::Base.transaction do
      attendances_correction_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.assign_attributes(item)
        attendance.save!(context: :bulk_submit)
        attendance.update!(change_one_month: false) if attendance.change_one_month?
      end
        flash[:success] = "1ヶ月分の勤怠情報を申請しました。"
        redirect_to user_url(date: params[:date])
    end 
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました."
    redirect_to corrections_apply_user_url(date: params[:date])
  end

  private

  def attendances_correction_params
    params.require(:user).permit(attendances:[:started_at, :finished_at, :note, :instructor_one_month_test, :tomorrow_one_month])[:attendances]
  end
end
