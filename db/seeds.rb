User.create!(
  name: "管理者",
  email: "sample@email.com",
  password: "password",
  password_confirmation: "password" ,
  affiliation: "フリーランス部",
  employee_number: 1,
  uid: "1",
  admin:true
)
             
User.create!(
  name: "上長A",
  email: "sampleA@email.com",
  password: "password",
  password_confirmation: "password" ,
  affiliation: "フリーランス部",
  employee_number: 2,
  uid: "2",
  superior:true
)
             
User.create!(
  name: "上長B",
  email: "sampleB@email.com",
  password: "password",
  password_confirmation: "password",
  affiliation: "フリーランス部",
  employee_number: 3,
  uid: "3",
  superior:true
)
             
User.create!(
  name: "一般ユーザー1",
  email: "sample-1@email.com",
  password: "password",
  password_confirmation: "password",
  affiliation: "フリーランス部",
  employee_number: 4,
  uid: "4"
)
             
User.create!(
  name: "一般ユーザー２",
  email: "sample-2@email.com",
  password: "password",
  password_confirmation: "password",
  affiliation: "フリーランス部",
  employee_number: 5,
  uid: "5"
)
             
puts "Users Created"


Place.create!(
  number: 2,
  name: "拠点A",
  working_style: "勤怠"
)

puts "Places Created"
