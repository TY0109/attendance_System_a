module AttendancesHelper
  # TODO: デコレータ移行
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  def overtime_notice(attendance)
    if attendance.instructor_test && ! attendance.change?
      return "#{attendance.instructor_test}に残業申請中"
    elsif attendance.change?
      if attendance.approval?
        return "残業承認済"
      elsif attendance.denial?
        return "残業否認"
      else
        return "#{attendance.instructor_test}に残業申請中"
      end
    end
  end
  
  def one_month_notice(attendance)
    # 上長を入力せず""になる場合を考慮し、".present? 必須 
    if attendance.instructor_one_month_test.present? && ! attendance.change_one_month?
      return "#{attendance.instructor_one_month_test}に勤怠編集申請中"
    elsif attendance.change_one_month?
      if attendance.approvement?
        return "勤怠編集承認済"
      elsif attendance.deniment?
        return "勤怠編集否認"
      end
    end
  end
  
  def working_times(start, finish, tomorrow)
    hours = (finish - start) / 3600.0
    hours += 24 if tomorrow
    format('%.2f', hours)
  end

  # def attendance_invalid?
  #   attendances=true
  #   attendances_params.each do |id, item| 
  #     if item[:started_at].blank? && item[:finished_at].blank? && item[:instructor_one_month_test].blank?
  #       next
  #     elsif item[:started_at].present? && item[:finished_at].present? && item[:instructor_one_month_test].present?
  #       next
  #     elsif item[:started_at].present? && item[:finished_at].blank? && item[:instructor_one_month_test].blank?
  #       next
  #     elsif item[:started_at].blank? && item[:finished_at].present? && item[:instructor_one_month_test].blank?
  #       next
  #     elsif item[:started_at].present? && item[:finished_at].present? && item[:instructor_one_month_test].blank?
  #       next
  #     elsif item[:started_at].present? && item[:finished_at].blank? && item[:instructor_one_month_test].present?
  #       attendances=false
  #       break
  #     elsif item[:started_at].blank? && item[:finished_at].present? && item[:instructor_one_month_test].present?
  #       attendances=false
  #       break
  #     elsif item[:started_at].blank? && item[:finished_at].blank? && item[:instructor_one_month_test].present?
  #       attendances=false
  #       break
  #     end
  #   end
  #   return attendances
  # end
end