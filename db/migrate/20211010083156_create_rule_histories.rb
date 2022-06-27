class CreateRuleHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :rule_histories do |t|
      t.references :rule, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
