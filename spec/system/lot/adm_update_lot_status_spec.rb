require 'rails_helper'

describe 'Adm update status' do

    it 'and approves' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        other_adm = User.create!(name: 'adm2', cpf: '96267093085', email: 'adm2@leilaodogalpao.com.br', password: 'password')
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

    it 'and cancels status' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)
        # Act
        login_as(adm)
        visit root_path
        click_on 'Lotes Expirados'
        click_on 'Cancelar'

        # Assert
        expect(current_path).to eq expired_lots_lots_path
        expect(page).to have_content('Lote cancelado com sucesso!')
        expect(lot.reload.status).to eq('canceled')
        expect(page).not_to have_button('Cancelar')
    end

    it 'and closes status' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)
        Bid.create!(user_id: user.id, lot_id: lot.id, amount: 50)

        # Act
        login_as(adm)
        visit root_path
        click_on 'Lotes Expirados'
        click_on 'Encerrar'

        # Assert
        expect(current_path).to eq expired_lots_lots_path
        expect(page).to have_content('Lote encerrado com sucesso!')
        expect(lot.reload.status).to eq('closed')
        expect(page).not_to have_button('Encerrar')
    end
end