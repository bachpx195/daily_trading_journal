class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :name
      t.integer :rule_type
      t.text :content

      t.timestamps
    end
  end
end
