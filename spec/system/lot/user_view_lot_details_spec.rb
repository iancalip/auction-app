require 'rails_helper'

describe 'User log in' do
    it 'and sees lot details' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        #Act
        login_as(user)
        visit root_path
        click_on 'Ver Detalhes'
        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content('Código do lote: ABC123456')
        expect(page).to have_content("Data do leilão : #{1.days.from_now.to_date}")
        expect(page).to have_content("Fim do leilão: #{3.days.from_now.to_date}")
        expect(page).to have_content('Oferta mínima: R$49.9')
        expect(page).to have_content('Lance mínimo: R$19.9')
    end

    it 'but cant see adm features' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm, status: :approved)
        #Act
        login_as(user)
        visit root_path
        click_on 'Ver Detalhes'
        #Assert
        expect(page).not_to have_button('Aprovar')
        expect(page).not_to have_link('Editar')
        expect(page).not_to have_button('Adicionar Produto')
        expect(page).not_to have_button('Cancelar')
        expect(page).not_to have_content('Status: Aprovado')
    end
end