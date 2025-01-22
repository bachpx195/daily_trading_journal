class CreateWeekMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :week_masters do |t|
      t.date :start_date
      t.integer :month
      t.integer :year
      t.integer :overlap_month
      t.integer :number_in_month

      t.timestamps
    end
    add_index :week_masters, :start_date
  end
end
