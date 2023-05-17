require 'rails_helper'

describe 'User sign in' do
    it 'successfully' do
        #Arrange
        User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
        #Act
        visit root_path
        within('nav') do
            click_on 'Login'
        end
        fill_in 'E-mail', with: 'teste@email.com'
        fill_in 'Senha', with: 'password'
        click_on 'Log in'

        #Assert
        within('nav') do
            expect(page).not_to have_link 'Login'
            expect(page).to have_button 'Sair'
            expect(page).to have_content 'Teste | teste@email.com'
        end
        expect(page).to have_link 'Meus Lotes'
        expect(page).to have_link 'Produtos'
        expect(page).to have_content 'Login efetuado com sucesso'
        expect(page).not_to have_link 'Cadastrar Produto'
        expect(page).not_to have_link 'Criar Lote'
    end

    it 'and logs out' do
        #Arrange
        user = User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
        #Act
        login_as user
        visit root_path
        click_on 'Sair'
        #Assert
        expect(page). to have_link 'Login'
        expect(page).not_to have_button 'Sair'
        expect(page).to have_content 'Logout efetuado com sucesso'
        expect(page).not_to have_content 'Teste | teste@email.com'
    end
end