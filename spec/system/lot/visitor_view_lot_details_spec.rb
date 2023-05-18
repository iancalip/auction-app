require 'rails_helper'

describe 'Visitor' do
    it 'sees lot details' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        #Act
        visit root_path
        click_on 'Ver Detalhes'
        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_link('Leilão')
        expect(page).to have_link('Login')
        expect(page).to have_content('Detalhes do Lote')
        expect(page).to have_content('Código do Lote: ABC123456')
        expect(page).to have_content("Início do Leilão: #{1.day.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do Leilão: #{3.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta Mínima Inicial: R$49.9')
        expect(page).to have_content('Diferença Mínima para Lance: R$19.9')
    end

    it 'sees products within lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        visit lot_path(lot)

        #Arrange
        expect(page).to have_content('Produtos do Lote')
        expect(page).to have_content('Iphone')
        expect(page).to have_content("#{product.description}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).to have_content('Ver Detalhes')
    end

    it 'cant see adm features' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm, status: :approved)
        #Act
        visit lot_path(lot)

        #Assert
        expect(page).not_to have_button('Aprovar')
        expect(page).not_to have_link('Editar')
        expect(page).not_to have_button('Adicionar Produto')
        expect(page).not_to have_button('Cancelar')
        expect(page).not_to have_content('Status: Aprovado')
    end

    it 'cant access pending lots details' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm, status: :pending)
        #Act
        visit lot_path(lot)

        #Assert
        expect(current_path).to eq root_path
        expect(page).to have_content('Lote indisponível')
    end
end