class AddInstructorCompReplyToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_comp_reply, :integer
  end
end
