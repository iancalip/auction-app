require 'rails_helper'

describe 'user tries to make a bid' do
    it 'and succeed' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)
        fill_in 'Valor do Lance', with: 2600.0
        click_on 'Enviar Lance'

        #Arrange
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content('Lance feito com sucesso')
        expect(page).to have_content('Oferta Atual: R$ 2600.0')
        expect(page).to have_content('Lance Mínimo Esperado: R$ 2670.1')
    end

    it 'but didnt match minimum bid value when is first to make a bid' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)
        fill_in 'Valor do Lance', with: 30.0
        click_on 'Enviar Lance'

        #Arrange
        expect(current_path).to eq lot_bids_path(lot)
        expect(page).not_to have_content('Lance feito com sucesso')
        expect(page).to have_content('Oferta Atual: Nenhum lance realizado')
        expect(page).to have_content('Lance Mínimo Esperado: R$ 2500.0')
        expect(page).to have_content('Valor deve ser maior ou igual ao lance mínimo.')
    end

    it 'but didnt match minimum bid difference' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        other_user = User.create!(name: 'other user', cpf: '02324252481', email: 'other.user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        Bid.create!(lot_id: lot.id, user_id: other_user.id, amount: 2500.0)

        #Act
        login_as user
        visit lot_path(lot)
        fill_in 'Valor do Lance', with: 30.0
        click_on 'Enviar Lance'

        #Arrange
        expect(current_path).to eq lot_bids_path(lot)
        expect(page).not_to have_content('Lance feito com sucesso')
        expect(page).to have_content('Oferta Atual: R$ 2500.0')
        expect(page).to have_content('Lance Mínimo Esperado: R$ 2570.1')
        expect(page).to have_content('Valor deve ser maior que a diferença mínima entre os lances')
    end
end