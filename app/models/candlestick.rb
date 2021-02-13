class Candlestick < ApplicationRecord
<<<<<<< HEAD
  belongs_to :merchandise_rate
=======
  belongs_to :currency_pair
>>>>>>> 612f21f (upload)

  enum time_type: {day: 1}
end
