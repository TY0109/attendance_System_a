class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.integer :number
      t.string :name
      t.string :working_style

      t.timestamps
    end
  end
end
