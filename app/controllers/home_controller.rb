class HomeController < ApplicationController
    def index
        @ongoing_lots = approved_lots.select { |lot| lot.start_date <= Date.current && lot.end_date >= Date.current }
        @upcoming_lots = approved_lots.select { |lot| lot.start_date > Date.current }

        if current_user&.admin?
            @pending_lots = Lot.pending.where('end_date > ?', Date.current).order(start_date: :asc, end_date: :asc)
        end
    end

    def search
        if current_user&.admin?
            @lots = Lot.search_adm(params[:q]).distinct
        else
            @lots = Lot.ongoing_lots.search(params[:q]).distinct
        end
        render :index
    end

    private

    def approved_lots
        Lot.approved.order(start_date: :asc, end_date: :asc)
    end
end
