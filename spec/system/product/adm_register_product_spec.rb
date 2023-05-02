require 'rails_helper'

describe 'ADM faz login' do
    it 'e vê link Cadastrar produto' do
        #Arrange
        User.create!(name: 'adm', cpf: '000.000.000-00', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        visit root_path
        within('nav') do
            click_on 'Login'
        end
        within('form') do
            fill_in 'E-mail', with: 'adm@leilaodogalpao.com.br'
            fill_in 'Senha', with: 'password'
            click_on 'Log in'
        end
        #Assert
        within('nav') do
            expect(page).not_to have_link 'Login'
            expect(page).to have_button 'Sair'
            expect(page).to have_content 'adm@leilaodogalpao.com.br'
        end
        expect(page).to have_content 'Login efetuado com sucesso'
        expect(page).to have_link 'Cadastrar produto'
    end

    it 'e vê página de cadastro de produto' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '000.000.000-00', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar produto'
        #Assert
        expect(page).to have_field('Name')
        expect(page).to have_field('Weight')
        expect(page).to have_field('Width')
        expect(page).to have_field('Height')
        expect(page).to have_field('Depth')
        expect(page).to have_field('Category')
        expect(page).to have_field('Description')
        expect(page).to have_field('image', type: 'file')
    end

    it 'cadastra produto e volta pra tela inicial' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '000.000.000-00', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar produto'

        fill_in 'Name', with: 'Produto'
        fill_in 'Weight', with: 8000
        fill_in 'Width', with: 70
        fill_in 'Height', with: 45
        fill_in 'Depth', with: 10
        fill_in 'Category', with: 'categoria'
        fill_in 'Description', with: 'descrição'
        click_on 'Enviar'

        #Assert
       expect(page).to have_content('Produto cadastrado com sucesso')
       expect(current_path).to eq root_path
    end

    it 'mas deixa campos obrigatórios em branco ao cadastrar produto' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '000.000.000-00', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar produto'

        fill_in 'Name', with: ''
        fill_in 'Weight', with: nil
        fill_in 'Width', with: nil
        fill_in 'Height', with: nil
        fill_in 'Depth', with: nil
        fill_in 'Category', with: ''
        fill_in 'Description', with: ''
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Produto não cadastrado, preencha todos os campos.')
        expect(page).to have_content('Name não pode ficar em branco')
        expect(page).to have_content('Description não pode ficar em branco')
        expect(page).to have_content('Weight não pode ficar em branco')
        expect(page).to have_content('Width não pode ficar em branco')
        expect(page).to have_content('Height não pode ficar em branco')
        expect(page).to have_content('Depth não pode ficar em branco')
        expect(page).to have_content('Category não pode ficar em branco')
        expect(current_path).to eq new_product_path
    end

    it 'mas não preenche com os formatos de dados corretos ao cadastrar produto' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '000.000.000-00', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar produto'

        fill_in 'Name', with: 'produto'
        fill_in 'Weight', with: 'a'
        fill_in 'Width', with: 'a'
        fill_in 'Height', with: 'a'
        fill_in 'Depth', with: 'a'
        fill_in 'Category', with: 'categoria'
        fill_in 'Description', with: 'descrição'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Weight não é um número')
        expect(page).to have_content('Width não é um número')
        expect(page).to have_content('Height não é um número')
        expect(page).to have_content('Depth não é um número')
    end
end