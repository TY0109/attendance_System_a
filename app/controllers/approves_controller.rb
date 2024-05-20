class ApprovesController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :correct_general_user
  
  # 残業申請内容確認ページ
  def check_overtime_state
    @first_day = params[:date]
    @attendances = Attendance.where(instructor_test: @user.name, change: false)
  end
  
  # 残業の承認内容が送信される
  def change_overtime_state
    begin
      ActiveRecord::Base.transaction do
        attendances_overtime_params.each do |id, item|
          attendance = Attendance.find(id)
          attendance.assign_attributes(item)
          attendance.save!(context: :change_overtime_state)
        end
      end
      flash[:success] = "変更内容を送信しました"
    rescue ActiveRecord::RecordInvalid 
      flash[:danger] = "無効な入力データがあった為、変更をキャンセルしました。"
    ensure
      redirect_to user_url(date: params[:date])
    end
  end

  #１か月の勤怠編集の申請内容を見て承認するページ＃
  def check_correction_state
    @attendances = Attendance.where(instructor_one_month_test: @user.name, change_one_month:false)
  end
  
  #１か月の勤怠編集の承認内容が送信されるページ#
  def change_correction_state
    ActiveRecord::Base.transaction do
      attendances_correction_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.assign_attributes(item)
        attendance.save!(context: :change_correction_state)
        attendance.update(reply_updated_at: Time.current.change(sec:0))
      end
    end
    flash[:success] = "変更内容を送信しました"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、変更をキャンセルしました。"
    redirect_to approves_check_monthly_state_user_url
  end

  # 勤怠完全版申請状況を確認するページ edit相当
  def check_monthly_state
    @monthly_states = MonthlyState.where(request_instructor: @user.name, change: false)
  end
  
  # 勤怠完全版申請の承認/否認などの状態を変更 update相当
  def change_monthly_state
    begin
      ActiveRecord::Base.transaction do
        monthly_state_params.each do |id, item|
          monthly_state = MonthlyState.find(id)
          monthly_state.assign_attributes(item)
          monthly_state.save!(context: :change_monthly_state)
        end
      end
      flash[:success] = "変更内容を送信しました"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、変更をキャンセルしました。"
    ensure
      redirect_to user_url
    end
  end

  private
  
  # appコントローラから継承したものを上書き
  def correct_general_user
    if current_user.admin? || !current_user.superior?
      flash[:danger]="権限がありません"
      redirect_to(root_url)
    end
  end

  def attendances_overtime_params
    params.require(:user).permit(attendances:[:instructor_reply, :change, :user_id])[:attendances]
  end

  def attendances_correction_params
    params.require(:user).permit(attendances:[:instructor_one_month_reply, :change_one_month, :user_id])[:attendances]
  end

  def monthly_state_params
    params.require(:user).permit(monthly_states:[:instructor_reply, :change, :user_id])[:monthly_states]
  end
end
