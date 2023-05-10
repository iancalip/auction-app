require 'rails_helper'

describe 'ADM faz login' do
    it 'e vê link Cadastrar produto' do
        #Arrange
        User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
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
            expect(page).to have_content 'adm | adm@leilaodogalpao.com.br'
        end
        expect(page).to have_content 'Login efetuado com sucesso'
        expect(page).to have_link 'Cadastrar Produto'
    end

    it 'e vê página de cadastro de produto' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar Produto'
        #Assert
        expect(page).to have_field('Nome')
        expect(page).to have_field('Peso')
        expect(page).to have_field('Largura')
        expect(page).to have_field('Altura')
        expect(page).to have_field('Profundidade')
        expect(page).to have_field('Categoria')
        expect(page).to have_field('Descrição')
        expect(page).to have_field('image', type: 'file')
    end

    it 'cadastra produto e volta pra tela inicial' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar Produto'

        fill_in 'Nome', with: 'Produto'
        fill_in 'Peso', with: 8000
        fill_in 'Largura', with: 70
        fill_in 'Altura', with: 45
        fill_in 'Profundidade', with: 10
        fill_in 'Categoria', with: 'Categoria'
        fill_in 'Descrição', with: 'Descrição'
        attach_file('image', Rails.root.join('spec/support/test_image.jpg'))
        click_on 'Enviar'
        #Assert
       expect(page).to have_content('Produto cadastrado com sucesso')
       expect(current_path).to eq root_path
    end

    it 'mas deixa campos obrigatórios em branco ao cadastrar produto' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar Produto'

        fill_in 'Nome', with: ''
        fill_in 'Peso', with: nil
        fill_in 'Largura', with: nil
        fill_in 'Altura', with: nil
        fill_in 'Profundidade', with: nil
        fill_in 'Categoria', with: ''
        fill_in 'Descrição', with: ''
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Produto não cadastrado, preencha todos os campos.')
        expect(page).to have_content('Nome não pode ficar em branco')
        expect(page).to have_content('Descrição não pode ficar em branco')
        expect(page).to have_content('Peso não pode ficar em branco')
        expect(page).to have_content('Largura não pode ficar em branco')
        expect(page).to have_content('Altura não pode ficar em branco')
        expect(page).to have_content('Profundidade não pode ficar em branco')
        expect(page).to have_content('Categoria não pode ficar em branco')
        expect(page).to have_content('Imagem não pode ficar em branco')
        expect(current_path).to eq products_path
    end

    it 'mas não preenche com os formatos de dados corretos ao cadastrar produto' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path
        click_on 'Cadastrar Produto'

        fill_in 'Nome', with: 'Produto'
        fill_in 'Peso', with: 'a'
        fill_in 'Largura', with: 'a'
        fill_in 'Altura', with: 'a'
        fill_in 'Profundidade', with: 'a'
        fill_in 'Categoria', with: 'Categoria'
        fill_in 'Descrição', with: 'Descrição'
        attach_file('image', Rails.root.join('spec/support/test_image.jpg'))
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Peso não é um número')
        expect(page).to have_content('Largura não é um número')
        expect(page).to have_content('Altura não é um número')
        expect(page).to have_content('Profundidade não é um número')
    end
end