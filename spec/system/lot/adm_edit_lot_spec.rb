require 'rails_helper'

describe 'User log in' do
    it 'and sees edit page' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm)
        #Act
        login_as(adm)
        visit root_path
        click_on 'Ver Detalhes'
        click_on 'Editar'
        #Assert
        expect(current_path).to eq edit_lot_path(lot)
        expect(page).to have_field('Código do lote', with: "ABC123456")
        expect(page).to have_field('Data do leilão', with: 1.day.from_now.to_date)
        expect(page).to have_field('Fim do leilão', with: 3.days.from_now.to_date)
        expect(page).to have_field('Oferta mínima', with: 49.90)
        expect(page).to have_field('Lance mínimo', with: 19.90)
    end

    it 'and edits lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm)
        #Act
        login_as(adm)
        visit root_path
        click_on 'Ver Detalhes'
        click_on 'Editar'
        fill_in 'Código do lote', with: 'XYZ987654'
        fill_in 'Data do leilão', with: 5.days.from_now
        fill_in 'Fim do leilão', with: 10.days.from_now
        fill_in 'Oferta mínima', with: 20.0
        fill_in 'Lance mínimo', with: 15.0
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Lote atualizado com sucesso')
        expect(page).to have_content("XYZ987654")
        expect(page).to have_content(5.day.from_now.to_date)
        expect(page).to have_content(10.days.from_now.to_date)
        expect(page).to have_content('Oferta mínima: R$20.0')
        expect(page).to have_content('Lance mínimo: R$15.0')
    end

    it 'and fail to edit lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm)
        #Act
        login_as(adm)
        visit root_path
        click_on 'Ver Detalhes'
        click_on 'Editar'
        fill_in 'Código do lote', with: ''
        fill_in 'Data do leilão', with: nil
        fill_in 'Fim do leilão', with: nil
        fill_in 'Oferta mínima', with: nil
        fill_in 'Lance mínimo', with: nil
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Código do lote não pode ficar em branco')
        expect(page).to have_content('Código do lote deve ter 3 letras maiúsculas seguidas de 6 números')
        expect(page).to have_content('Data do leilão não pode ficar em branco')
        expect(page).to have_content('Fim do leilão não pode ficar em branco')
        expect(page).to have_content('Oferta mínima não pode ficar em branco')
        expect(page).to have_content('Lance mínimo não pode ficar em branco')
    end

end