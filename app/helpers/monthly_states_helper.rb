module MonthlyStatesHelper
  def monthly_state_notice(monthly_state)
    if monthly_state.request_instructor && ! monthly_state.change?
      return "#{monthly_state.request_instructor}に勤怠申請中"
    elsif monthly_state.change?
      if monthly_state.approval?
        return "勤怠承認済"
      elsif monthly_state.denial?
        return "勤怠否認"
      end
    else
      return "所属長承認 未"
    end
  end
end
