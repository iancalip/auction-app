class BidsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_lot

    def create
        @bid = Bid.new(bid_params)
        set_references

        if @bid.save
          redirect_to @lot, notice: 'Lance feito com sucesso.'
        else
          @products = @lot.products
          flash[:error] = 'Ocorreu um erro ao fazer o lance.'
          render 'lots/show'
        end
    end

    private

    def set_lot
        @lot = Lot.find(params[:lot_id])
    end

    def bid_params
        params.require(:bid).permit(:amount)
    end

    def set_references
        @bid.lot = @lot
        @bid.user = current_user
    end
end