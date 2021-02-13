class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.datetime :public_time
      t.integer :public_status, null: false, default: 0
      t.string :intro_image
      t.text :content
      t.string :description

      t.timestamps
    end
  end
end
