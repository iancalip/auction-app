require 'rails_helper'

describe 'Adm log in' do
    it 'and sees approve button' do
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
        expect(page).to have_content('Status: Aguardando aprovação')
        expect(page).to have_content('Código do lote: ABC123456')
        expect(page).to have_content("Data do leilão : #{1.days.from_now.to_date}")
        expect(page).to have_content("Fim do leilão: #{3.days.from_now.to_date}")
        expect(page).to have_content('Oferta mínima: R$49.9')
        expect(page).to have_content('Lance mínimo: R$19.9')
        expect(page).to have_button('Aprovar')
        expect(page).to have_button('Cancelar')
        expect(page).to have_link('Adicionar Produto')
        expect(page).to have_link('Editar')
    end

    it 'and updates status' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        other_adm = User.create!(name: 'adm2', cpf: '86160256505', email: 'adm2@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: other_adm)
        #Act
        login_as(adm)
        visit root_path
        click_on 'Ver Detalhes'
        click_on 'Aprovar'
        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content('Status: Aprovado')
        expect(lot.reload.approved_by_user_id).to eq(adm.id)
        expect(page).not_to have_button('Aprovar')
        expect(page).not_to have_button('Adicionar Produto')
        expect(page).to have_button('Cancelar')
        expect(page).to have_link('Editar')
    end


    #lembrete para adicionar testes para atualização de status para cancelado, posteriormente
end