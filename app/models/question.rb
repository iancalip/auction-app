class Question < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_many :answers
end
