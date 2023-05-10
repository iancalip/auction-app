require 'rails_helper'

RSpec.describe User, type: :model do
    describe '#valido?' do
        it 'se usuário é ADM' do
            #Arrange
            user = User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            #Assert
            expect(user.admin?).to eq(false)
            expect(adm.admin?).to eq(true)
        end

        it 'se CPF está em uso' do
            #Arrange
            user = User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
            user_2 = User.new(name: 'Adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
            #Assert
            expect(user_2).not_to be_valid
            expect(user_2.errors[:cpf]).to include("já está em uso")
        end

        it 'se CPF é válido' do
            #Arrange
            user = User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
            user_2 = User.new(name: 'Adm', cpf: '65465465465', email: 'adm@leilaodogalpao.com.br', password: 'password')
            #Assert
            expect(user).to be_valid
            expect(user_2).not_to be_valid
            expect(user_2.errors[:cpf]).to include("inválido")
        end

        it 'se CPF tem o tamanho adequado' do
            #Arrange
            user = User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
            user_2 = User.new(name: 'Adm', cpf: '654654654', email: 'adm@leilaodogalpao.com.br', password: 'password')
            #Assert
            expect(user).to be_valid
            expect(user_2).not_to be_valid
            expect(user_2.errors[:cpf]).to include("deve conter 11 dígitos")
        end

        it 'check E-mail' do
            #Arrange
            user = User.create!(name: 'Teste', cpf: '02324252481', email: 'teste@email.com', password: 'password')
            user_2 = User.new(name: 'Adm', cpf: '12213531447', email: 'teste@email.com', password: 'password')
            #Assert
            expect(user_2).not_to be_valid
            expect(user_2.errors[:email]).to include("já está em uso")
        end

        it 'check password' do
            #Arrange
            user = User.new(name: 'Teste', cpf: '12213531447', email: 'teste@email.com', password: '12345')
            #Assert
            expect(user).not_to be_valid
            expect(user.errors[:password]).to include("é muito curto (mínimo: 6 caracteres)")
        end
    end
end
