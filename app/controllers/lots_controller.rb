class LotsController < ApplicationController
    before_action :set_lot, only: [:show, :edit, :update, :update_products, :assign_products, :approve_status, :cancel_status, :close_status]
    before_action :authenticate_admin!, only: [:create, :update, :edit, :approve_status, :cancel_status, :close_status, :expired]
    before_action :authenticate_user!, only: [:index]

    def index
        @lots = Lot.joins(:bids).where(bids: { user_id: current_user.id }).distinct
    end

    def show
        return redirect_to root_path, notice: "Lote indisponível" if @lot.pending? && !current_user&.admin?
        @products = @lot.products
        @bid = Bid.new
    end

    def new
        @lot = Lot.new
    end

    def create
        @lot = Lot.new(lot_params)
        @lot.created_by_user = current_user
        if @lot.save
            redirect_to @lot, notice: 'Lote criado com sucesso'
        else
            flash.now[:notice] = 'Não foi possível criar o lote, preencha todos os campos.'
            render :new
        end
    end

    def edit; end

    def update
        if @lot.pending? && lot_params[:product_ids].present?
            @lot.products.each { |product| product.update(lot: nil) }
            Product.where(id: lot_params[:product_ids]).update_all(lot_id: @lot.id)
        end

        if @lot.update(lot_params.except(:product_ids))
            redirect_to @lot, notice: 'Lote atualizado com sucesso'
        else
            flash.now[:notice] = 'Lote não atualizado, preencha todos os campos.'
            render :new
        end
    end

    def approve_status
        if @lot.products.any? && current_user.id != @lot.created_by_user_id &&  @lot.pending?
            @lot.approved! && @lot.update(approved_by_user_id: current_user.id)
            redirect_to @lot, notice: 'Lote aprovado com sucesso!'
        else
            redirect_to @lot, notice: 'Você não tem permissão para isso'
        end
    end

    def cancel_status
        @lot.canceled!
        @lot.products.update(lot_id: nil)
        redirect_to expired_lots_path, notice: 'Lote cancelado com sucesso!'
    end

    def close_status
        @lot.closed!
        redirect_to expired_lots_path, notice: 'Lote encerrado com sucesso!'
    end

    def expired
        @lots = Lot.where('end_date < ? OR status = ?', Date.current, 8)
    end

    def assign_products
        @products = Product.where('lot_id IS NULL OR lot_id = ?', @lot.id)
    end

    def update_products
        product_ids = params[:product_ids]&.map(&:to_i)
        @lot.products.where.not(id: product_ids).update_all(lot_id: nil)
        Product.where(id: product_ids).update_all(lot_id: @lot.id)
        redirect_to lot_path(@lot), notice: 'Lote atualizado com sucesso!'
    end

    private

    def authenticate_admin!
        unless current_user&.admin?
            redirect_to root_path, alert: 'Apenas administradores podem executar essa ação.'
        end
    end

    def set_lot
        @lot = Lot.find(params[:id])
    end

    def lot_params
        params.require(:lot).permit(:code, :start_date, :end_date, :minimum_bid, :minimum_bid_difference, product_ids: [])
    end
end
