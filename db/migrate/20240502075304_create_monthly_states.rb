class CreateMonthlyStates < ActiveRecord::Migration[5.1]
  def change
    create_table :monthly_states do |t|
      t.date :worked_in
      t.string :request_instructor
      t.integer :instructor_reply
      t.boolean :change, default:false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
