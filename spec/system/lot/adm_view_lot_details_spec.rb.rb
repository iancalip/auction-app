require 'rails_helper'

describe 'Adm logs in' do
    it 'and sees lot details' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        other_adm = User.create!(name: 'adm2', cpf: '86160256505', email: 'adm2@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: other_adm)
        #Act
        login_as(adm)
        visit root_path
        click_on 'Ver Detalhes'

        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_link('Leilão')
        expect(page).to have_button('Sair')
        expect(page).to have_content("#{adm.name}")
        expect(page).to have_content("#{adm.email}")
        expect(page).to have_content('Detalhes do Lote')
        expect(page).to have_content('Status: Aguardando aprovação')
        expect(page).to have_content('Código do lote: ABC123456')
        expect(page).to have_content("Data do leilão: #{1.day.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do leilão: #{3.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta mínima: R$49.9')
        expect(page).to have_content('Lance mínimo: R$19.9')
        expect(page).to have_button('Aprovar')
        expect(page).to have_button('Cancelar')
        expect(page).to have_link('Adicionar Produto')
        expect(page).to have_link('Editar')
        expect(page).not_to have_content('Produtos do Lote')
    end

    it 'and see products within lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit lot_path(lot)

        #Arrange
        expect(page).to have_content('Produtos do Lote')
        expect(page).to have_content('Iphone')
        expect(page).to have_content("#{product.description}")
        expect(page).to have_selector("img[src$='product_iphone.jpg']")
        expect(page).to have_content('Ver Detalhes')
    end


    it 'and sees approve button' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        other_adm = User.create!(name: 'otther_adm', cpf: '96267093085', email: 'otheradm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: other_adm, status: :pending)
        #Act
        login_as adm
        visit root_path
        click_on 'Ver Detalhes'
        #Assert
        expect(page).to have_button('Aprovar')
        expect(page).to have_link('Editar')
        expect(page).to have_button('Adicionar Produto')
        expect(page).to have_button('Cancelar')
        expect(page).to have_content('Status: Aguardando Aprovação')
    end
end