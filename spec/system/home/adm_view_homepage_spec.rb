require 'rails_helper'

describe 'Admin view homepage' do
    it 'and sees title but there is no content' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        #Act
        login_as adm
        visit root_path

        #Assert
        expect(page).to have_link('LeilON')
        expect(page).to have_button('Sair')
        expect(page).to have_content("#{adm.name}")
        expect(page).to have_content("#{adm.email}")
        expect(page).to have_content('Não existem lotes cadastrados')
        expect(page).not_to have_selector("img[src$='Iphone.jpg']")
        expect(page).not_to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Em Breve')
        expect(page).not_to have_content('Aguardando Aprovação')
    end

    it 'and there is ongoing lots' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit root_path

        #Assert
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{Date.current.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Em Breve')
        expect(page).not_to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Não existem lotes cadastrados')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end

    it 'and there is upcoming lots' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                         minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit root_path

        #Assert
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{1.day.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_content('Em Breve')
        expect(page).not_to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Não existem lotes cadastrados')
    end

    it 'and there is all types of lots' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        second_lot = Lot.create!(code: 'XYZ987654', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                                minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        third_lot = Lot.create!(code: 'LMN147258', start_date: 7.day.from_now, end_date: 10.days.from_now, minimum_bid: 250.0,
                                minimum_bid_difference: 7.0, created_by_user: adm, status: :pending)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        other_product = Product.new(name: 'Produto', weight: 8000 , width: 70, height: 45, depth: 20,
                                category: 'categoria', description: 'descrição', lot_id: second_lot.id)
        other_product.image.attach(io: File.open(Rails.root.join('spec/support/Cadeira_Gamer.jpg')),
                                filename: 'Cadeira_Gamer.jpg', content_type: 'image/jpeg')
        other_product.save!

        #Act
        login_as adm
        visit root_path

        #Assert
        expect(page).to have_content('Lotes Disponíveis')
        expect(page).to have_content('XYZ987654')
        expect(page).to have_content("#{Date.current.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='Cadeira_Gamer.jpg']")
        expect(page).to have_content('Em Breve')
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{1.day.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).to have_content('Aguardando Aprovação')
        expect(page).to have_content('Lotes Disponíveis')
        expect(page).to have_content('LMN147258')
        expect(page).to have_content("#{7.day.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{10.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_link('Ver Detalhes')
        expect(page).not_to have_content('Não existem lotes cadastrados')
    end

    it 'and there is pending lots' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '64725165026', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :pending)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit root_path

        #Assert
        expect(page).not_to have_content('Não existem lotes cadastrados')
        expect(page).to have_content('ABC123456')
        expect(page).to have_content("#{Date.current.strftime("%d/%m/%Y")}")
        expect(page).to have_content("#{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_content('Aguardando Aprovação')
        expect(page).not_to have_content('Lotes Disponíveis')
        expect(page).not_to have_content('Em Breve')
    end
end