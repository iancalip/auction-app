require 'rails_helper'

describe 'visit tries to see the bid form' do
    it 'sucessfully' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)

        #Arrange
        expect(page).to have_content('Oferta Atual: Nenhum lance realizado')
        expect(page).to have_content('Lance Mínimo Esperado: R$ 2500.0')
        expect(page).to have_content("Faça uma Oferta")
        expect(page).to have_content('Valor do Lance')
        expect(page).to have_button('Enviar Lance')
    end

    it 'and fails on an upcoming lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 2.days.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)

        #Arrange
        expect(page).not_to have_content('Oferta Atual')
        expect(page).not_to have_content('Lance Mínimo Esperado')
        expect(page).not_to have_content("Faça uma Oferta")
        expect(page).not_to have_content('Valor do Lance')
        expect(page).not_to have_button('Enviar Lance')
    end
end