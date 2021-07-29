class AddComlumnsToIdea < ActiveRecord::Migration[5.2]
  def change
    add_column :ideas, :status, :integer
    add_column :ideas, :start_at, :datetime
    add_column :ideas, :rating, :float
  end
end
