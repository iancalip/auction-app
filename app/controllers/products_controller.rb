class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :edit, :update]

    def index
        if current_user&.admin?
            @products = Product.all
        else
            @products = Product.joins(:lot).where("lots.status = ? AND lots.end_date > ?", 4, Date.current)
        end
    end


    def show; end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            redirect_to root_path, notice: 'Produto cadastrado com sucesso'
        else
            flash.now[:notice] = 'Produto não cadastrado, preencha todos os campos.'
            render :new
        end
    end

    def edit; end

    def update
        if @product.update(product_params)
            redirect_to @product, notice: 'Produto atualizado com sucesso'
        else
            flash.now[:notice] = 'Produto não atualizado, preencha todos os campos.'
            render :new
        end
    end


    private

    def set_product
        @product = Product.find(params[:id])
    end

    def product_params
        params.require(:product).permit(:name, :description, :image, :weight, :width, :height, :depth, :category, :identifier)
    end
end