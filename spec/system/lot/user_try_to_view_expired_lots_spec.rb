require 'rails_helper'

describe 'User log in' do
    it 'and fails to see expired lots' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '51959723030', email: 'user@email.com', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)
        #Act
        login_as(user)
        visit expired_lots_path

        #Assert
        expect(current_path).to eq root_path
        expect(page).to have_content('Apenas administradores podem executar essa ação.')
    end
end