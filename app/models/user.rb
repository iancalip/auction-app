class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    email.end_with?('@leilaodogalpao.com.br')
  end
end
