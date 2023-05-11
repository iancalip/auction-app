require 'rails_helper'

describe 'Adm update status' do

    it 'sucessfully' do
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