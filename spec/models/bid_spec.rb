require 'rails_helper'

RSpec.describe Bid, type: :model do
    describe '#valid?' do

        it 'invalid when it didnt overcome minimum bid' do
            #Arrange
            adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
            user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
            lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                            minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
            product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
            product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
            product.save!
            bid = Bid.new(lot_id: lot.id, user_id: user.id, amount: 300.0)
            #Assert
            expect(bid).not_to be_valid
            expect(bid.errors[:amount]).to include('deve ser maior ou igual ao lance mínimo.')
        end

        it 'invalid when nil' do
            #Arrange
            adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
            user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
            lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                            minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
            product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
            product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
            product.save!
            bid = Bid.new(lot_id: lot.id, user_id: user.id, amount: nil)
            #Assert
            expect(bid).not_to be_valid
            expect(bid.errors[:amount]).to include('não pode ficar em branco')
        end

        it 'when it doesnt match minimum bid difference' do
            #Arrange
            adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
            user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
            other_user = User.create!(name: 'other user', cpf: '02324252481', email: 'other.user@email.com.br', password: 'password')
            lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                            minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
            product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                    category: 'categoria', description: 'celular caro', lot_id: lot.id)
            product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                    filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
            product.save!
            bid = Bid.create!(lot_id: lot.id, user_id: other_user.id, amount: 2500.0)
            other_bid = Bid.new(lot_id: lot.id, user_id: user, amount: 2510.0)

            #Arrange
            expect(other_bid).not_to be_valid
            expect(other_bid.errors[:amount]).to include('deve ser maior que a diferença mínima entre os lances.')
        end
    end
end
