require 'rails_helper'

describe 'Adm log in' do
    it 'and sees link to create lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as(adm)
        visit root_path
        #Assert
        expect(page).to have_link 'Criar Lote'
    end

    it 'and sees creation form' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        # Act
        login_as adm
        visit root_path
        click_on 'Criar Lote'

        # Assert
        expect(page).to have_field('Código do Lote')
        expect(page).to have_field('Início do Leilão')
        expect(page).to have_field('Fim do Leilão')
        expect(page).to have_field('Oferta Mínima Inicial')
        expect(page).to have_field('Diferença Mínima para Lance')
    end

    it 'creates lot and see details' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        # Act
        login_as adm
        visit root_path
        click_on 'Criar Lote'
        fill_in 'Código do Lote', with: 'ABC123456'
        fill_in 'Início do Leilão', with: 5.days.from_now.to_date
        fill_in 'Fim do Leilão', with: 10.days.from_now.to_date
        fill_in 'Oferta Mínima Inicial', with: 20
        fill_in 'Diferença Mínima para Lance', with: 15
        click_on 'Enviar'

        # Assert
        expect(current_path).to eq lot_path(Lot.last.id)
        expect(page).to have_link('Editar')
        expect(page).not_to have_button('Aprovar')
        expect(page).to have_button('Cancelar')
        expect(page).to have_content('Lote criado com sucesso')
        expect(page).to have_content('Código do Lote: ABC123456')
        expect(page).to have_content("Início do Leilão: #{5.day.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do Leilão: #{10.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta Mínima Inicial: R$20.0 ')
        expect(page).to have_content('Diferença Mínima para Lance: R$15.0')
        expect(page).to have_link('Adicionar Produto')
    end

    it 'and fails to create lot' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        # Act
        login_as adm
        visit root_path
        click_on 'Criar Lote'
        fill_in 'Código do Lote', with: ''
        fill_in 'Início do Leilão', with: nil
        fill_in 'Fim do Leilão', with: nil
        fill_in 'Oferta Mínima Inicial', with: nil
        fill_in 'Diferença Mínima para Lance', with: nil
        click_on 'Enviar'

        # Assert
        expect(page).to have_content('Código do Lote não pode ficar em branco')
        expect(page).to have_content('Código do Lote deve ter 3 letras maiúsculas seguidas de 6 números')
        expect(page).to have_content('Início do Leilão não pode ficar em branco')
        expect(page).to have_content('Fim do Leilão não pode ficar em branco')
        expect(page).to have_content('Oferta Mínima Inicial não pode ficar em branco')
        expect(page).to have_content('Diferença Mínima para Lance não pode ficar em branco')
    end
end
