require 'rails_helper'

describe 'Adm adds product to lot' do
    it 'sucessfully' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro')
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                            minimum_bid_difference: 70.0, created_by_user: adm)
        #Act
        login_as(adm)
        visit root_path
        click_on 'Ver Detalhes'
        click_on 'Adicionar Produto'
        check "product_#{product.id}"
        click_on 'Salvar'

        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content('Produtos vinculados ao lote com sucesso!')
        expect(page).to have_content('Código do lote: ABC123456')
        expect(page).to have_content("Data do leilão : #{1.day.from_now.to_date}")
        expect(page).to have_content("Fim do leilão: #{3.day.from_now.to_date}")
        expect(page).to have_content('Oferta mínima: R$2500.0')
        expect(page).to have_content('Lance mínimo: R$70.0')
        expect(page).to have_content('Status: Aguardando aprovação')
        expect(page).to have_link('Editar')
        expect(page).to have_button('Cancelar')
        expect(page).to have_link('Adicionar Produto')
        #lembrete p adicionar o produto nessa view depois
    end

    it 'and cant add same product to another lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm)
        other_lot = Lot.create!(code: 'XYZ123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 60,
                        minimum_bid_difference: 20, created_by_user: adm)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        #Act
        login_as(adm)
        visit assign_products_lot_path(other_lot)

        #Assert
        expect(current_path).to eq assign_products_lot_path(other_lot)
        expect(page).to have_content("Adicionar Produtos: Lote - #{other_lot.code}")
        expect(page).to have_button('Salvar')
        expect(page).not_to have_content('Iphone')
    end

    it 'but cant see add product button' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        adm2 = User.create!(name: 'adm2', cpf: '86160256505', email: 'adm2@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm, status: :approved)
        #Act
        login_as(adm2)
        visit root_path
        click_on 'Ver Detalhes'

        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_link('Editar')
        expect(page).to have_button('Cancelar')
        expect(page).not_to have_button('Aprovar')
        expect(page).not_to have_link('Adicionar Produto')
    end
end