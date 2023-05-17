require 'rails_helper'

describe 'Adm log in' do
    it 'and approve status' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        adm2 = User.create!(name: 'adm2', cpf: '51959723030', email: 'adm2@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        #Act
        login_as(adm2)
        patch approve_status_lot_path(lot)

        #Assert
        expect(response).to redirect_to lot_path(lot)
        expect(flash.notice).to eq 'Lote aprovado com sucesso!'
        expect(lot.reload.status).to eq('approved')
    end

    it 'and fail to update his own lot status' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        #Act
        login_as(adm)
        patch approve_status_lot_path(lot)

        #Assert
        expect(response).to redirect_to lot_path(lot)
        expect(flash.notice).to eq 'Você não tem permissão para isso'
        expect(lot.reload.status).to eq('pending')
    end

    it 'and cancels status' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 10.days.ago, end_date: 1.day.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)

        # Act
        login_as(adm)
        patch cancel_status_lot_path(lot)

        # Assert
        expect(response).to redirect_to expired_lots_path
        expect(flash.notice).to eq 'Lote cancelado com sucesso!'
        expect(lot.reload.status).to eq('canceled')
    end

    it 'and closes status' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 10.days.ago, end_date: 1.day.ago, minimum_bid: 49.9,
                          minimum_bid_difference: 19.9, created_by_user: adm)

        # Act
        login_as(adm)
        patch close_status_lot_path(lot)

        # Assert
        expect(response).to redirect_to expired_lots_path
        expect(flash.notice).to eq 'Lote encerrado com sucesso!'
        expect(lot.reload.status).to eq('closed')
    end
end