require 'rails_helper'

describe 'visitors tries to make a bid' do
    it 'but they cant' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        visit lot_path(lot)
        fill_in 'Valor do Lance', with: 2600.0
        click_on 'Enviar Lance'

        #Arrange
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content('Para continuar, faça login ou registre-se')
    end
end