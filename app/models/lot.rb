class Lot < ApplicationRecord

    has_many :products
    has_many :bids

    enum status: { pending: 0, approved: 4, closed: 6, canceled: 8 }

    belongs_to :created_by_user, class_name: 'User'
    belongs_to :approved_by_user, class_name: 'User', optional: true

    validates :code, :start_date, :end_date, :minimum_bid, :minimum_bid_difference,
              :created_by_user_id, presence: true
    validates :code, uniqueness: true
    validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/, message: "deve ter 3 letras maiúsculas seguidas de 6 números" }
    validate :check_date
    validate :check_admin, on: :update


    def highest_bid
        bids.order(amount: :desc).first
    end

    def ongoing?
        start_date <= Date.current && end_date >= Date.current
    end

    def check_approval(current_user)
        products.any? && current_user.id != created_by_user_id &&  pending? && start_date > Date.current
    end

    def check_admin
        if status_changed?(from: "pending", to: "approved") && (created_by_user_id == approved_by_user_id)
            errors.add(:approved_by_user_id, 'não pode ser o mesmo usuário que criou o lote')
        end
    end

    def check_date
        if start_date.present? && end_date.present?
            return errors.add(:end_date, 'deve ser futura à data de criação') if start_date >= end_date
        end
    end

    def winner(current_user)
        highest_bid.user == current_user
    end

    def self.search(query)
        approved.joins(:products).where("lots.code LIKE ? OR products.name LIKE ?", "%#{query}%", "%#{query}%")
    end

    def self.search_adm(query)
        left_outer_joins(:products).where("lots.code LIKE ? OR products.name LIKE ?", "%#{query}%", "%#{query}%")
    end

    def self.ongoing_lots
        where('end_date > ? AND status = ?', Date.current, 4)
    end
end
