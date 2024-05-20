class MonthlyStatesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_general_user

  # 勤怠完全版申請が送信される
  def submit_monthly_state
    monthly_state = @user.monthly_states.find_by(worked_in: params[:date].to_date)
    monthly_state.assign_attributes(monthly_state_params)
    # 複数回申請できるようにchange: falseに更新
    if monthly_state.save(context: :submit_monthly_state)
      monthly_state.update(change: false) if monthly_state.change?
      flash[:success]="申請に成功しました"
    else
      flash[:danger]="申請に失敗しました"
    end
    redirect_to user_url(@user, date: params[:date])
  end
  
  private

  def monthly_state_params
    params.require(:monthly_state).permit(:worked_in,:request_instructor)
  end
end
