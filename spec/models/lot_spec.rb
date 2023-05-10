require 'rails_helper'

RSpec.describe Lot, type: :model do
  describe '#valid?' do
        it 'invalid when code is blank' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: '', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                            minimum_bid_difference: 19.90, created_by_user: adm)

            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:code]).to include('não pode ficar em branco')
        end

        it 'invalid when code is not in the correct format' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: '123456789', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                            minimum_bid_difference: 19.90, created_by_user: adm)

            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:code]).to include('deve ter 3 letras maiúsculas seguidas de 6 números')
        end

        it 'invalid when code is not in the correct length' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: '1234567', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                            minimum_bid_difference: 19.90, created_by_user: adm)

            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:code]).to include('deve ter 3 letras maiúsculas seguidas de 6 números')
        end

        it 'invalid when start date is not in the future' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: 'ABC123456', start_date: 2.day.ago, end_date: 3.days.from_now, minimum_bid: 49.90,
                            minimum_bid_difference: 19.90, created_by_user: adm)
            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:start_date]).to include('deve ser uma data futura')
        end

        it 'invalid when end date is not in the future' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.ago, minimum_bid: 49.90,
                            minimum_bid_difference: 19.90, created_by_user: adm)
            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:end_date]).to include('deve ser futura à data de criação')
        end

        it 'invalid minimum bid is nil' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: nil,
                            minimum_bid_difference: 19.90, created_by_user: adm)
            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:minimum_bid]).to include('não pode ficar em branco')
        end

        it 'invalid minimum bid difference is nil' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 50,
                            minimum_bid_difference: nil, created_by_user: adm)
            #Assert
            expect(lot).not_to be_valid
            expect(lot.errors[:minimum_bid_difference]).to include('não pode ficar em branco')
        end

        it 'valid when status is pending by default' do
            #Arrange
            adm = User.create!(name: 'Adm', cpf: '12213531447', email: 'adm@leilaodogalpao.com.br', password: 'password')
            lot = Lot.new(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 50,
                            minimum_bid_difference: nil, created_by_user: adm)
            #Assert
            expect(lot.status).to eq 'pending'
        end
    end
end
