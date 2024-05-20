class OvertimesController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :correct_general_user

  # 残業申請ページ
  def apply
    @first_day = params[:date]
    @attendance = @user.attendances.find(params[:attendance_id])
    @superior = User.where(superior: true).where.not(id: @user.id)
  end
  
  # 残業申請が送信される
  def submit
    attendance = @user.attendances.find(params[:attendance_id])
    attendance.assign_attributes(attendance_overtime_params)
    if attendance.save(context: :submit)
      # 2回目以降の申請に対応
      attendance.update(change: false) if attendance.change?
      flash[:success]="残業申請を受け付けました"
      redirect_to user_url(@user, date: params[:date])
    else
      flash[:danger]="残業申請に失敗しました"
      redirect_to user_url(@user, date: params[:date])
    end
  end

  private

  def attendance_overtime_params
    params.require(:attendance).permit(:scheduled_end_time, :business_outline, :tomorrow, :instructor_test)
  end
end
