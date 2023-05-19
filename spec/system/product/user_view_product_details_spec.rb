require 'rails_helper'

describe 'user view product details' do
    it 'sucessfully' do
        #Arrange
        user = User.create!(name: 'user', cpf: '51959723030', email: 'user@email.com', password: 'password')
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.days.ago, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400.0 , width: 10.0, height: 16.0, depth: 2.0,
                                category: 'Celular', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit products_path
        click_on 'Ver Detalhes'

        #Assert
        expect(current_path).to eq product_path(product)
        expect(page).to have_content('Detalhes do Produto')
        expect(page).to have_content('Nome: Iphone')
        expect(page).to have_content('Peso: 400.0 g')
        expect(page).to have_content('Largura: 10.0 cm')
        expect(page).to have_content('Altura: 16.0 cm')
        expect(page).to have_content('Profundidade: 2.0 cm')
        expect(page).to have_content('Categoria: Celular')
        expect(page).to have_content('Descrição: Descrição')
        expect(page).to have_content('Atualmente no Lote: ABC123456')
        expect(page).to have_link("#{product.lot.code}")
        expect(page).not_to have_link('Editar')
        expect(page).to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end

    it 'sucessfully and clicks on lot code' do
        #Arrange
        user = User.create!(name: 'user', cpf: '51959723030', email: 'user@email.com', password: 'password')
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.days.ago, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400.0 , width: 10.0, height: 16.0, depth: 2.0,
                                category: 'Celular', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit products_path
        click_on 'Ver Detalhes'
        click_on 'ABC123456'

        #Assert
        expect(current_path).to eq lot_path(lot)
    end
end

