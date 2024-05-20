Rails.application.routes.draw do
  root 'static_pages#top'

  get 'signup' , to: 'users#new'
  
  get 'login', to: 'sessions#new'
  post 'login' ,to: 'sessions#create'
  delete 'logout' ,to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'  # ←使わない
      patch 'update_basic_info'
      # get 'attendances/edit_one_month_request'
      # patch 'attendances/update_one_month_request'
      # get 'attendances/edit_overtime_notice'
      # patch 'attendances/update_overtime_notice'
      # get 'attendances/edit_one_month_notice'
      # patch 'attendances/update_one_month_notice'
      # get 'attendances/edit_comp_notice'
      # patch 'attendances/update_comp_notice'

      # 出勤社員一覧ページ用
      get 'attendances/working'
      # 承認ログページ用
      get 'attendances/history'
      # CSV出力用
      get 'attendances/output'

      # 残業申請
      get 'overtimes/apply'
      patch 'overtimes/submit'
      # 残業承認
      get 'approves/check_overtime_state'
      patch 'approves/change_overtime_state'

      # 1か月の勤怠編集申請
      get 'corrections/apply'
      patch 'corrections/bulk_submit'
      # 1か月の勤怠編集承認
      get 'approves/check_correction_state'
      patch 'approves/change_correction_state'

      # 勤怠完全版承認
      get 'approves/check_monthly_state'
      patch 'approves/change_monthly_state'
    end
    
    # CSV入力用
    collection {post :import}
    
    resources :attendances, only: :update do
      # member do
        # get 'edit_overtime_request'
        # patch 'update_overtime_request'
        # patch 'update_comp_request'
      # end
    end
    
    # 勤怠完全版申請
    patch 'monthly_states/submit_monthly_state'
  end
  
  resources :places 
end
