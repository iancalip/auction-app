require 'rails_helper'

RSpec.describe User, type: :model do
    it 'check se user é ADM' do
        #Arrange
        user = User.create!(name: 'Teste', cpf: '000.000.000-01', email: 'teste@email.com', password: 'password')
        adm = User.create!(name: 'Ian', cpf: '000.000.000-00', email: 'ian@leilaodogalpao.com.br', password: 'password')
        #Assert
        expect(user.admin?).to eq(false)
        expect(adm.admin?).to eq(true)
    end

    it 'check CPF' do
        #Arrange
        user = User.create!(name: 'Teste', cpf: '000.000.000-00', email: 'teste@email.com', password: 'password')
        user_2 = User.new(name: 'Ian', cpf: '000.000.000-00', email: 'ian@leilaodogalpao.com.br', password: 'password')
        #Assert
        expect(user_2).not_to be_valid
        expect(user_2.errors[:cpf]).to include("já está em uso")
    end

    it 'check E-mail' do
        #Arrange
        user = User.create!(name: 'Teste', cpf: '000.000.000-01', email: 'teste@email.com', password: 'password')
        user_2 = User.new(name: 'Ian', cpf: '000.000.000-00', email: 'teste@email.com', password: 'password')
        #Assert
        expect(user_2).not_to be_valid
        expect(user_2.errors[:email]).to include("já está em uso")
    end

    it 'check password' do
        #Arrange
        user = User.new(name: 'Teste', cpf: '000.000.000-00', email: 'teste@email.com', password: '12345')
        #Assert
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("é muito curto (mínimo: 6 caracteres)")
    end
end
