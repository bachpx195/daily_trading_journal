class FundLog < ApplicationRecord
  validates :change_type, presence: true
  enum change_type: {profit: 0, loss: 1, deposit: 2, withdraw: 3, deposit_fee: 4, fee: 5}
  
  before_create :update_fund
  before_update :update_fund
  before_destroy :revert_fund

  def revert_fund
    if self.profit? || self.deposit?
      Fund.first.update(present_value: (Fund.first.present_value - self.change_amount.to_f))
    elsif self.loss? || self.withdraw?
      Fund.first.update(present_value: (Fund.first.present_value + self.change_amount.to_f))
    elsif self.deposit_fee?
      Fund.first.update_attributes(present_value: (Fund.first.present_value + self.change_amount.to_f), fee: (Fund.first.fee - self.change_amount.to_f))
    elsif self.fee?
      Fund.first.update(fee: (Fund.first.fee + self.change_amount.to_f))
    end
  end
  
  private
  def update_fund
    if self.profit? || self.deposit?
      Fund.first.update(present_value: (Fund.first.present_value + self.change_amount.to_f))
    elsif self.loss? || self.withdraw?
      Fund.first.update(present_value: (Fund.first.present_value - self.change_amount.to_f))
    elsif self.deposit_fee?
      Fund.first.update_attributes(present_value: (Fund.first.present_value - self.change_amount.to_f), fee: (Fund.first.fee + self.change_amount.to_f))
    elsif self.fee?
      Fund.first.update(fee: (Fund.first.fee - self.change_amount.to_f))
    end
  end
end
