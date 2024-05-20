class AddTomorrowOneMonthToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :tomorrow_one_month, :boolean, default:false
  end
end
