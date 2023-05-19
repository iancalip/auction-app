require 'rails_helper'

describe 'Adm login' do
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
        expect(page).to have_field('Código do Lote', with: "ABC123456")
        expect(page).to have_field('Início do Leilão', with: 1.day.from_now.to_date)
        expect(page).to have_field('Fim do Leilão', with: 3.days.from_now.to_date)
        expect(page).to have_field('Oferta Mínima Inicial', with: 49.90)
        expect(page).to have_field('Diferença Mínima para Lance', with: 19.90)
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
        fill_in 'Código do Lote', with: 'XYZ987654'
        fill_in 'Início do Leilão', with: 5.days.from_now
        fill_in 'Fim do Leilão', with: 10.days.from_now
        fill_in 'Oferta Mínima Inicial', with: 20.0
        fill_in 'Diferença Mínima para Lance', with: 15.0
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Lote atualizado com sucesso')
        expect(page).to have_content("XYZ987654")
        expect(page).to have_content("Início do Leilão: #{5.day.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do Leilão: #{10.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta Mínima Inicial: R$20.0')
        expect(page).to have_content('Diferença Mínima para Lance: R$15.0')
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
        fill_in 'Código do Lote', with: ''
        fill_in 'Início do Leilão', with: nil
        fill_in 'Fim do Leilão', with: nil
        fill_in 'Oferta Mínima Inicial', with: nil
        fill_in 'Diferença Mínima para Lance', with: nil
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Código do Lote não pode ficar em branco')
        expect(page).to have_content('Código do Lote deve ter 3 letras maiúsculas seguidas de 6 números')
        expect(page).to have_content('Início do Leilão não pode ficar em branco')
        expect(page).to have_content('Fim do Leilão não pode ficar em branco')
        expect(page).to have_content('Oferta Mínima Inicial não pode ficar em branco')
        expect(page).to have_content('Diferença Mínima para Lance não pode ficar em branco')
    end

end