class AddOneMonthToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_one_month_reply, :integer
    add_column :attendances, :change_one_month, :boolean, default:false
  end
end
