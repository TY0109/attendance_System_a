class AddInstructorEditTestToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_one_month_test, :string
  end
end
