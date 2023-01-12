class User < ApplicationRecord
  
  has_many :attendances, dependent: :destroy
  
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
    self.remember_token=User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remmeber_token)
    return false if remmeber_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest,nil)
  end
  
  
  
  #csvファイルの内容をDBに登録する
  def self.import(file)
    imported_num = 0
  #   #文字コード変換のためにKernel#openとCSV#newを併用
  #   #参考： http://qiita.com/labocho/items/8559576b71642b79df67
    open(file.path,undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row) #エラーが出る。第1行目をヘッダーとして読み込み
      csv.each do |row|
        next if row.header_row?  #それぞれの行を読み込んでいくが、ヘッダーはすでに読み込んでいるのでとばす？

  #     #CSVの行情報をHASH(ryby表示)に変換
        table = Hash[[row.headers, row.fields].transpose]
        
  #       #登録済みデータ情報を探す
        user = find_by(:email=> table['email'])
        #登録されてなければ作成
        if user.nil?
          user= new
        end
        
  #       # user = find_by(:email=> table['email'])が存在しなければ、user=newの後、ここの処理へ。
          # user = find_by(:email=> table['email'])が存在すれば、user=newなしでここの処理へ。
        user.attributes = table.to_hash.slice(
          *table.to_hash.except(:id, :created_at, :updated_at).keys)
          
  #       #バリデーションokの場合は保存(新規作成、更新どちらも)
        if user.valid?
          user.save!
          imported_num += 1
        end
      end
    end

  #   #更新件数を返却
    imported_num
  end

  
end
