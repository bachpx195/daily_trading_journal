class Plan < ApplicationRecord
  has_many :idea_plans
  has_many :ideas, through: :idea_plans

  has_many :plan_merchandise_rates
  has_many :merchandise_rates, through: :plan_merchandise_rates

  accepts_nested_attributes_for :plan_merchandise_rates, allow_destroy: true
  accepts_nested_attributes_for :idea_plans, allow_destroy: true
  acts_as_nested_set

  enum status: {draft: 0, open: 1, close: 2}
  enum category: {other: 0, daily: 1, weekly: 2, monthly: 3, termly: 4}

  def parent_id= parent_id
    if parent_id == "#"
      move_to_root
    else
      super parent_id
    end
  end

  def new_position= new_position
    if parent.blank?
      prev_node = root.siblings[new_position.to_i - 1]
      move_to_right_of prev_node
    else
      move_to_child_with_index parent, new_position.to_i
      parent.reload
    end
  end
end
