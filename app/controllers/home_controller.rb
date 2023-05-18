class HomeController < ApplicationController
    def index
        @ongoing_lots = approved_lots.select { |lot| lot.start_date <= Date.current && lot.end_date >= Date.current }
        @upcoming_lots = approved_lots.select { |lot| lot.start_date > Date.current }

        if current_user&.admin?
            @pending_lots = Lot.pending.where('end_date > ?', Date.current).order(start_date: :asc, end_date: :asc)
        end
    end


    private

    def approved_lots
        Lot.approved.order(start_date: :asc, end_date: :asc)
    end
end
