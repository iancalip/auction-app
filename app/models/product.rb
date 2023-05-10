class Product < ApplicationRecord

  before_validation :generate_identifier, on: :create

  belongs_to :lot, optional: true

  validates :name, :description, :weight, :width, :height, :depth, :category, :identifier, :image, presence: true
  validates :weight, :width, :height, :depth, numericality: true
  validates :identifier, uniqueness: true
  validates :identifier, length: { is: 10 }

  has_one_attached :image

  private

  def generate_identifier
    self.identifier = SecureRandom.alphanumeric(10)
  end
end

