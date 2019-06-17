class FundLog < ApplicationRecord
  validates :name, presence: true
  enum change_type: {profit: 0, loss: 1, deposit: 2, withdraw: 3, deposit_fee: 4, fee: 5}
end
