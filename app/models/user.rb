class User < ApplicationRecord
  
  has_many :attendances, dependent: :destroy
  has_many :monthly_states, dependent: :destroy

  attr_accessor :remember_token
  
  before_save { self.email=email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, presence:true, length:{maximum: 50}
  validates :email, presence:true, length:{maximum:100},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness:true
  
  has_secure_password
  validates :password, presence:true, length:{minimum:6}, allow_nil:true
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remmeber_token)
    return false if remmeber_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest,nil)
  end
  
  # csvファイルの内容をDBに登録し、成功した件数を返却
  def self.import(file)
    # 戻り値(一番大事な値)を冒頭に定義
    imported_num = 0
    debugger
    CSV.foreach(file.path, headers: true) do |row|
      # Emailが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(email: row["email"]) || new
      # CSVの行情報をハッシュ(ruby表示)に変換
      user.attributes = row.to_hash
      # TODO: バリデーションに失敗したら、処理を全て中断しDBをもとの状態に戻すようtransactionが必要
      imported_num += 1 if user.save!
    end
    # 更新件数を返却
    imported_num
  end
end

# 中身メモ
# CSV.read(file.path, headers: true).map{|row| row}
#[
  # <CSV::Row "name":"濱本 亮" "email":"a5@gmail.com" "affiliation":"フリーランス部" "employee_number":"1" "uid":"1" "basic_work_time":"8:00" "designated_work_start_time":"10:00" "designated_work_end_time":"19:00" "superior":"TRUE" "admin":"FALSE" "password":"password">, 
  #<CSV::Row "name":"まさる" "email":"abcd@yahoo.co.jp" "affiliation":"フリーランス部" "employee_number":"2" "uid":"2" "basic_work_time":"8:00" "designated_work_start_time":"20:00" "designated_work_end_time":"5:00" "superior":"FALSE" "admin":"FALSE" "password":"password">
# ]

# CSV.read(file.path, headers: true).map{|row| row.headers}
# [["name", "email", "affiliation", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"], ["name", "email", "affiliation", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"]]

# CSV.read(file.path, headers: true).map{|row| row.fields}
# [["濱本 亮", "a5@gmail.com", "フリーランス部", "1", "1", "8:00", "10:00", "19:00", "TRUE", "FALSE", "password"], ["まさる", "abcd@yahoo.co.jp", "フリーランス部", "2", "2", "8:00", "20:00", "5:00", "FALSE", "FALSE", "password"]]

# headers: trueにしない場合
# CSV.read(file.path).map{|row| row}
# [
  # ["name", "email", "affiliation", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"], 
  # ["濱本 亮", "a5@gmail.com", "フリーランス部", "1", "1", "8:00", "10:00", "19:00", "TRUE", "FALSE", "password"], 
  # ["まさる", "abcd@yahoo.co.jp", "フリーランス部", "2", "2", "8:00", "20:00", "5:00", "FALSE", "FALSE", "password"]
# ]
