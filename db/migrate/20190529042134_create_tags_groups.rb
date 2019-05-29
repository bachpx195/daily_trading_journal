class CreateTagsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :tags_groups do |t|
      t.references :group, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
