require 'rails_helper'

describe 'adm tries to see expired lots' do
    it 'and sees cancel button' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        # Act
        login_as adm
        visit root_path
        click_on 'Lotes Expirados'

        # Assert
        expect(current_path).to eq expired_lots_path
        expect(page).to have_content("Duração: #{lot.start_date.strftime('%d/%m/%Y')} - #{lot.end_date.strftime('%d/%m/%Y')}")
        expect(page).to have_content('Maior Lance: Nenhum lance realizado')
        expect(page).to have_content('Vencedor(a): Não houveram vencedores')
        expect(page).to have_button('Cancelar')
        expect(page).not_to have_button('Encerrar')
    end

    it 'and sees close button' do
        # Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        Bid.create!(user_id: user.id, lot_id: lot.id, amount: 2600.0)

        # Act
        login_as adm
        visit root_path
        click_on 'Lotes Expirados'

        # Assert
        expect(current_path).to eq expired_lots_path
        expect(page).to have_content("Duração: #{lot.start_date.strftime('%d/%m/%Y')} - #{lot.end_date.strftime('%d/%m/%Y')}")
        expect(page).to have_content('Maior Lance: R$ 2600.0')
        expect(page).to have_content("Vencedor(a): #{user.email}")
        expect(page).to have_button('Encerrar')
        expect(page).not_to have_button('Cancelar')
    end
end

