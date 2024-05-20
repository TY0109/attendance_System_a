class AddChangeCompToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_comp, :boolean, default:false
  end
end
