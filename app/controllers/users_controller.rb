class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit,:update,:destroy]
  before_action :logged_in_user, only:[:index, :show, :edit, :update, :destroy, :update_basic_info] 
  before_action :correct_general_user, only:[:edit, :update]
  before_action :admin_user, only:[:index,:destroy, :update_basic_info]
  before_action :correct_general_or_superior_user, only: :show  
  before_action :set_one_month, only: [:show]
  before_action :create_monthly_state_for_apply, only: [:show]

  def new
    if logged_in?
      flash[:info] = "すでにログインしています"
      redirect_to current_user
    end
    @user=User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規作成に成功しました"
      redirect_to @user
    else
      render :new
    end
  end
  
  def index
    @users = User.paginate(page:params[:page], per_page:30)
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count

    # 勤怠完全版申請に必要
    @superior = User.where(superior:true).where.not(id: @user.id)  
    @monthly_state_apply_state = @user.monthly_states.find_by(worked_in: @first_day)
    # @representative_attendance=@user.attendances.find_by(worked_on:@first_day) リファクタリング前

    # 以下は上長ビューにのみ表示
    # ・残業申請されているもの
    @requested_attendances = Attendance.where(instructor_test: @user.name).where(change: false)  
    # ・1か月の勤怠編集申請されているもの
    @one_month_requested_attendances = Attendance.where(instructor_one_month_test: @user.name, change_one_month: false)
    # ・勤怠完全版申請されているもの
    @monthly_state_applies = MonthlyState.where(request_instructor: @user.name, change: false)
  end
    
  def edit; end
  
  def update
    if @user.update(user_params)
      flash[:success ] = "ユーザー情報を編集しました"
      redirect_to @user
    else
      render :edit
    end
  end
    
  def destroy
    @user.destroy
    flash[:danger] = "#{@user.name}を削除しました"
    redirect_to users_url
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update(basic_info_params)
      flash[:success] = "基本情報を編集しました"
    end
    redirect_to users_url
  end
    
  def import
    if params[:csv_file].blank? || params[:csv_file].content_type != "text/csv"
      flash[:danger] = "読み込むCSVを選択してください"
    else
      num = User.import(params[:csv_file])
      flash[:success] = "#{ num.to_s }件のデータ情報を追加/更新しました"
    end
    redirect_to users_url
  end
  
  private
    def create_monthly_state_for_apply
      @monthly_state = @user.monthly_states.find_by(worked_in: @first_day)
      @user.monthly_states.create!(worked_in: @first_day) unless @monthly_state
      rescue ActiveRecord::RecordInvalid
        flash[:danger] = "失敗"
        redirect_to root_url
    end

    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name,:email, :password, :password_confirmation,
      :employee_number, :uid, :affiliation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end
