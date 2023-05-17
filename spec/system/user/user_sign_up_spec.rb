require 'rails_helper'

describe 'User sign up' do
    it 'successfully' do
        #Arrange
        #Act
        visit root_path
        click_on 'Login'
        click_on 'Sign up'
        within('form') do
            fill_in 'Nome', with: 'Teste'
            fill_in 'E-mail', with: 'teste@email.com'
            fill_in 'Senha', with: 'password'
            fill_in 'CPF', with: '02324252481'
            fill_in 'Confirme sua senha', with: 'password'
        end
        click_on 'Sign up'

        #Assert
        expect(page).to have_button 'Sair'
        expect(page).to have_content 'teste@email.com'
        expect(page).to have_content 'Usuário cadastrado com sucesso'
        expect(User.last.name).to eq 'Teste'
    end

    it 'and fails because of unavailable info' do
        #Arrange
        User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
        #Act
        visit root_path
        click_on 'Login'
        click_on 'Sign up'
        fill_in 'Nome', with: 'Teste'
        fill_in 'E-mail', with: 'teste@email.com'
        fill_in 'Senha', with: 'password'
        fill_in 'CPF', with: '02324252481'
        fill_in 'Confirme sua senha', with: 'password'
        click_on 'Sign up'

        #Assert
        expect(page).to have_content 'Não foi possível salvar usuário: 2 erros.'
        expect(page).to have_content 'CPF já está em uso'
        expect(page).to have_content 'E-mail já está em uso'
    end

    it 'and fails because of invalid password' do
        #Arrange
        #Act
        visit root_path
        click_on 'Login'
        click_on 'Sign up'
        fill_in 'Nome', with: 'Teste'
        fill_in 'E-mail', with: 'teste@email.com'
        fill_in 'Senha', with: '12345'
        fill_in 'Confirme sua senha', with: 'password'
        fill_in 'CPF', with: '02324252481'
        click_on 'Sign up'

        #Assert
        expect(page).to have_content 'Senha é muito curto (mínimo: 6 caracteres)'
    end
end