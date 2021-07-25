class CreateIdeaMerchandises < ActiveRecord::Migration[5.2]
  def change
    create_table :idea_merchandises do |t|
      t.references :idea, foreign_key: true
      t.references :merchandise, foreign_key: true

      t.timestamps
    end
  end
end
