class Rule < ApplicationRecord
  belongs_to :ruleable, polymorphic: true

	enum rule_type: {advice: 0, fixed_rule: 1}
end
