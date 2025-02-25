class AddColumnToEventMaster < ActiveRecord::Migration[5.2]
  def change
    add_reference :event_masters, :merchandise_rate, foreign_key: true, after: :id
  end
end
