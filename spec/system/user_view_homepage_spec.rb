require 'rails_helper'

describe 'Usuario visita tela incial' do
    it 'e vê o nome da app' do
        #Arrange
        #Act
        visit root_path
        #Assert
        expect(page).to have_content('Leilão')
    end

    # it 'e nao existem lotes cadastrados' do
    #     #Arrange
    #     #Act
    #     visit root_path
    #     #Assert
    #     expect(page).to have_content('Não existem lotes cadastrados')
    # end
end

