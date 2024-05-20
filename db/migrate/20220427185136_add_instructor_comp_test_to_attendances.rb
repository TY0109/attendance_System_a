class AddInstructorCompTestToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_comp_test, :string
  end
end
