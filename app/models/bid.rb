class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot

  validates :amount, presence: true

  validate :first_bid
  validate :bid

  def first_bid
    if amount && lot.bids.count.zero? && amount < lot.minimum_bid
      errors.add(:amount, "deve ser maior ou igual ao lance mínimo.")
    end
  end

  def bid
    if amount && lot.bids.count > 0 && amount <= (lot.bids.maximum(:amount) + lot.minimum_bid_difference)
      errors.add(:amount, "deve ser maior que a diferença mínima entre os lances.")
    end
  end
end
