class CreateDailyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_reports do |t|
      t.date :date
      t.references :coin, foreign_key: true
      t.references :new, foreign_key: true
      t.string :result

      t.timestamps
    end
  end
end
