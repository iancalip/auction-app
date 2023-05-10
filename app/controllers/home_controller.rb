class HomeController < ApplicationController
    def index
        @lots = Lot.where(status: :approved)
        @lots = Lot.all if current_user&.admin?
    end
end