class AddColumnsToDateEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :date_events, :merchandise_rate, foreign_key: true, after: :id
    add_reference :date_events, :day_analytic, foreign_key: true, after: :event_master_id
    add_column :date_events, :note, :text, after: :day_analytic_id
  end
end
