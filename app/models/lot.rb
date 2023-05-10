class Lot < ApplicationRecord

    has_many :products

    enum status: { pending: 0, approved: 4, canceled: 8 }

    belongs_to :created_by_user, class_name: 'User'
    belongs_to :approved_by_user, class_name: 'User', optional: true

    validates :code, :start_date, :end_date, :minimum_bid, :minimum_bid_difference,
              :created_by_user_id, presence: true
    validates :code, uniqueness: true
    validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/, message: "deve ter 3 letras maiúsculas seguidas de 6 números" }
    validate :check_date
    validate :check_admin, on: :update

    private

    def check_admin
        if status_changed?(from: "pending", to: "approved") && (created_by_user_id == approved_by_user_id)
            errors.add(:approved_by_user_id, 'não pode ser o mesmo usuário que criou o lote')
        end
    end

    def check_date
        if start_date.present? && end_date.present?
            if start_date >= end_date
                errors.add(:end_date, 'deve ser futura à data de criação')
            elsif start_date < Date.today || end_date < Date.today
                errors.add(:start_date, 'deve ser uma data futura')
            end
        end
    end
end
