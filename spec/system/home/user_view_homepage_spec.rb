require 'rails_helper'

describe 'User visit homepage' do

    it 'sucessfully' do
        #Arrange
        user = User.create!(name: 'user', cpf: '02324252481', email: 'user@email.com.br', password: 'password')
        #Act
        login_as user
        visit root_path
        #Assert
        expect(page).to have_link('Leilão')
        expect(page).to have_content("#{user.name}")
        expect(page).to have_content("#{user.email}")
        expect(page).not_to have_link('Sair')
        expect(page).not_to have_link('Criar Lote')
        expect(page).not_to have_link('Lotes Expirados')
        expect(page).not_to have_link('Cadastrar Produto')
    end

    it 'but there is no content' do
        #Arrange
        user = User.create!(name:'User', cpf: '02324252481', email: 'user@email.com', password: 'password')
        #Act
        login_as user
        visit root_path

        #Assert

        expect(page).to have_content('Não existem lotes cadastrados')
        expect(page).not_to have_css("img")
        expect(page).not_to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Em Breve')
        expect(page).not_to have_content('Aguardando Aprovação')
    end

    it 'and there is ongoing lots' do
        #Arrange
        user = User.create!(name:'User', cpf: '02324252481', email: 'user@email.com', password: 'password')
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        login_as user
        visit root_path

        #Assert
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{Date.current.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='product_iphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Em Breve')
        expect(page).not_to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Não existem lotes cadastrados')
    end

    it 'and there is upcoming lots' do
        #Arrange
        user = User.create!(name:'User', cpf: '02324252481', email: 'user@email.com', password: 'password')
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                         minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        login_as user
        visit root_path

        #Assert
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{1.day.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='product_iphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_content('Em Breve')
        expect(page).not_to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Não existem lotes cadastrados')
    end

    it 'and there is upcoming and ongoing lots' do
        #Arrange
        user = User.create!(name:'User', cpf: '02324252481', email: 'user@email.com', password: 'password')
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        other_lot = Lot.create!(code: 'XYZ987654', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!
        other_product = Product.new(name: 'Produto', weight: 8000 , width: 70, height: 45, depth: 20,
                                category: 'categoria', description: 'descrição', lot_id: other_lot.id)
        other_product.image.attach(io: File.open(Rails.root.join('spec/support/test_image.jpg')),
                                filename: 'test_image.jpg', content_type: 'image/jpeg')
        other_product.save!

        #Act
        login_as user
        visit root_path

        #Assert
        expect(page).to have_content('Lotes Disponíveis')
        expect(page).to have_content('XYZ987654')
        expect(page).to have_content("#{Date.current.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='test_image.jpg']")
        expect(page).to have_content('Em Breve')
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{1.day.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='product_iphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).not_to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Não existem lotes cadastrados')
    end

    it 'and there is pending lots' do
        #Arrange
        user = User.create!(name:'User', cpf: '02324252481', email: 'user@email.com', password: 'password')
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :pending)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'celular caro', lot_id: adm.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/product_iphone.jpg')),
                                filename: 'product_iphone.jpg', content_type: 'product_iphone.jpg')
        product.save!

        #Act
        login_as user
        visit root_path

        #Assert
        expect(page).to have_content('Não existem lotes cadastrados')
        expect(page).not_to have_content('ABC123456')
        expect(page).not_to have_content("#{Date.current.strftime("%d/%m/%Y")}")
        expect(page).not_to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).not_to have_selector("img[src$='product_iphone.jpg']")
        expect(page).not_to have_link('Ver Detalhes')
        expect(page).not_to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Em Breve')
    end
end

