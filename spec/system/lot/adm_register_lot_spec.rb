require 'rails_helper'

describe 'User log in' do
    it 'and sees link to create lot if admin' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as(adm)
        visit root_path
        #Assert
        expect(page).to have_link 'Criar Lote'
    end

    it 'and dont see link to create lot' do
        #Arrange
        user = User.create!(name: 'user', cpf: '02324252481', email: 'user@email.com.br', password: 'password')
        #Act
        login_as(user)
        visit root_path
        #Assert
        expect(page).not_to have_link 'Criar Lote'
    end

    it 'and sees creation form' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        # Act
        login_as adm
        visit root_path
        click_on 'Criar Lote'

        # Assert
        expect(page).to have_field('Código')
        expect(page).to have_field('Data do leilão')
        expect(page).to have_field('Fim do leilão')
        expect(page).to have_field('Oferta mínima')
        expect(page).to have_field('Lance mínimo')
    end

    it 'creates lot and see details' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        # Act
        login_as adm
        visit root_path
        click_on 'Criar Lote'
        fill_in 'Código', with: 'ABC123456'
        fill_in 'Data do leilão', with: 5.days.from_now.to_date
        fill_in 'Fim do leilão', with: 10.days.from_now.to_date
        fill_in 'Oferta mínima', with: 20
        fill_in 'Lance mínimo', with: 15
        click_on 'Enviar'

        # Assert
        expect(current_path).to eq lot_path(Lot.last.id)
        expect(page).to have_link('Editar')
        expect(page).not_to have_button('Aprovar')
        expect(page).to have_button('Cancelar')
        expect(page).to have_content('Lote criado com sucesso')
        expect(page).to have_content('Código do lote: ABC123456')
        expect(page).to have_content("Data do leilão: #{5.day.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do leilão: #{10.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta mínima: R$20.0 ')
        expect(page).to have_content('Lance mínimo: R$15.0')
        expect(page).to have_link('Adicionar Produto')
    end

    it 'and fails to create lot' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        # Act
        login_as adm
        visit root_path
        click_on 'Criar Lote'
        fill_in 'Código', with: ''
        fill_in 'Data do leilão', with: nil
        fill_in 'Fim do leilão', with: nil
        fill_in 'Oferta mínima', with: nil
        fill_in 'Lance mínimo', with: nil
        click_on 'Enviar'

        # Assert
        expect(page).to have_content('Código do lote não pode ficar em branco')
        expect(page).to have_content('Código do lote deve ter 3 letras maiúsculas seguidas de 6 números')
        expect(page).to have_content('Data do leilão não pode ficar em branco')
        expect(page).to have_content('Fim do leilão não pode ficar em branco')
        expect(page).to have_content('Oferta mínima não pode ficar em branco')
        expect(page).to have_content('Lance mínimo não pode ficar em branco')
    end
end
