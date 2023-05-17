require 'rails_helper'

describe 'user sign in' do
    it 'and see closed lots that they won' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :closed)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        Bid.create!(user_id: user.id, lot_id: lot.id, amount: 2600)
        #Act
        login_as(user)
        visit root_path
        click_on 'Meus Lotes'

        #Arrage
        expect(page).to have_content('Meus Lotes')
        expect(page).to have_content("#{lot.code}")
        expect(page).to have_content("Seu Último Lance: R$ 2.600,00")
        expect(page).to have_content('Encerrado')
    end

    it 'and sees own ongoing lots that they bid' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com', password: 'password')
        other_user = User.create!(name: 'other user', cpf: '02324252481', email: 'other_user@email.com', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.from_now, minimum_bid: 1500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        Bid.create!(user_id: other_user.id, lot_id: lot.id, amount: 1600)
        Bid.create!(user_id: user.id, lot_id: lot.id, amount: 1900)
        Bid.create!(user_id: other_user.id, lot_id: lot.id, amount: 2600)
        #Act
        login_as(user)
        visit lots_path(lot)

        #Arrage
        expect(page).to have_content('Lotes com Lances em Andamento')
        expect(page).to have_content("#{lot.code}")
        expect(page).to have_content("Último Lance: R$ 2.600,00")
        expect(page).to have_content("Seu Último Lance: R$ 1.900,00")
        expect(page).to have_content('Em Andamento')
    end

    it 'and see lots that they didnt win' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com', password: 'password')
        other_user = User.create!(name: 'other user', cpf: '02324252481', email: 'other_user@email.com', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 1500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :closed)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        Bid.create!(user_id: other_user.id, lot_id: lot.id, amount: 1600)
        Bid.create!(user_id: user.id, lot_id: lot.id, amount: 1900)
        Bid.create!(user_id: other_user.id, lot_id: lot.id, amount: 2600)
        #Act
        login_as(user)
        visit lots_path(lot)

        #Arrage
        expect(page).to have_content('Lotes com Lances não Adquiridos')
        expect(page).to have_content("#{lot.code}")
        expect(page).to have_content("Último Lance: R$ 2.600,00")
        expect(page).to have_content("Seu Último Lance: R$ 1.900,00")
        expect(page).to have_content('Encerrado')
    end
end