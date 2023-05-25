class User < ApplicationRecord

  has_many :questions
  has_many :answers

  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11, message: "deve conter 11 dígitos" }

  before_validation :check_cpf

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    email.end_with?('@leilaodogalpao.com.br')
  end


  private

  DENY_LIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
    01234567890
  ].freeze

  def cpf_validator(digito_1, digito_2)
    return false unless cpf[-2].to_i == digito_1
    cpf[-1].to_i == digito_2
  end

  def check_cpf
    return errors.add(:cpf, 'inválido') if DENY_LIST.include?(cpf)

    n = [10, 9, 8, 7, 6, 5, 4, 3, 2]
    n2 = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    digito_1 = 11 - cpf.unpack("a9a*")[0].split("").map(&:to_i).zip(n).map { |x, y| x * y }.sum % 11
    digito_1 = 0 if digito_1 >= 10
    digito_2 = 11 - cpf.unpack("a9a*")[0].insert(-1, digito_1.to_s).split("").map(&:to_i).zip(n2).map { |x, y| x * y }.sum % 11
    digito_2 = 0 if digito_2 >= 10

    unless cpf_validator(digito_1, digito_2)
      errors.add(:cpf, 'inválido')
    end
  end
end
