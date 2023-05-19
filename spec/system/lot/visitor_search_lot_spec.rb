require 'rails_helper'

describe 'visitor search lot from homepage' do
    it 'successfully using product name' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        other_lot = Lot.create!(code: 'CBA123456', start_date: 5.days.ago, end_date: 9.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                            category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                            filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        other_product = Product.new(name: 'Headphone', weight: 400, width: 20, height: 15, depth: 10,
                            category: 'categoria', description: 'Fone de ouvido ', lot_id: other_lot.id)
        other_product.image.attach(io: File.open(Rails.root.join('spec/support/Headphone.jpg')),
                            filename: 'Headphone.jpg', content_type: 'Headphone.jpg')
        other_product.save!

        #Act
        visit root_path
        fill_in 'Pesquisar Produtos em Lotes', with: 'Iphone'
        click_on 'Pesquisar'

        #Assert
        within('nav') do
            expect(page).to have_field('Pesquisar Produtos em Lotes')
            expect(page).to have_button('Pesquisar')
            expect(page).to have_link('Login')
            expect(page).to have_link('LeilON')
        end
        expect(current_path).to eq search_path
        expect(page).to have_content("Resultado da Busca por: #{product.name}")
        expect(page).to have_content("#{lot.code}")
        expect(page).not_to have_content("#{other_lot.code}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).not_to have_selector("img[src$='Headphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_link('Produtos')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).not_to have_link('Cadastrar Produto')
        expect(page).not_to have_link('Criar Lote')
        expect(page).not_to have_link('Lotes Expirados')
    end

    it 'successfully using lot code' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        other_lot = Lot.create!(code: 'CBA123456', start_date: 5.days.ago, end_date: 9.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                            category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                            filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        other_product = Product.new(name: 'Headphone', weight: 400, width: 20, height: 15, depth: 10,
                            category: 'categoria', description: 'Fone de ouvido ', lot_id: other_lot.id)
        other_product.image.attach(io: File.open(Rails.root.join('spec/support/Headphone.jpg')),
                            filename: 'Headphone.jpg', content_type: 'Headphone.jpg')
        other_product.save!

        #Act
        visit root_path
        fill_in 'Pesquisar Produtos em Lotes', with: 'ABC123456'
        click_on 'Pesquisar'

        #Assert
        expect(current_path).to eq search_path
        expect(page).to have_content("Resultado da Busca por: #{lot.code}")
        expect(page).to have_content("#{lot.code}")
        expect(page).not_to have_content("#{other_lot.code}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).not_to have_selector("img[src$='Headphone.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_link('Produtos')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).not_to have_link('Cadastrar Produto')
        expect(page).not_to have_link('Criar Lote')
        expect(page).not_to have_link('Lotes Expirados')
    end

    it 'cannot find lot without product' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)

        #Act
        visit root_path
        fill_in 'Pesquisar Produtos em Lotes', with: 'ABC123456'
        click_on 'Pesquisar'

        #Assert
        expect(current_path).to eq search_path
        expect(page).to have_content('Sua busca não retornou nenhum resultado.')
        expect(page).not_to have_content("Resultado da Busca por: Iphone")
        expect(page).not_to have_content("#{lot.code}")
        expect(page).not_to have_selector("img[src$='Iphone.jpg']")
        expect(page).not_to have_link('Ver Detalhes')
        expect(page).to have_link('Produtos')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).not_to have_link('Cadastrar Produto')
        expect(page).not_to have_link('Criar Lote')
        expect(page).not_to have_link('Lotes Expirados')
    end

    it 'cannot find product without lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                            category: 'categoria', description: 'Descrição', lot_id: nil)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                            filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        #Act
        visit root_path
        fill_in 'Pesquisar Produtos em Lotes', with: 'Iphone'
        click_on 'Pesquisar'

        #Assert
        expect(current_path).to eq search_path
        expect(page).to have_content('Sua busca não retornou nenhum resultado.')
        expect(page).not_to have_content("Resultado da Busca por: Iphone")
        expect(page).not_to have_content("#{lot.code}")
        expect(page).not_to have_selector("img[src$='Iphone.jpg']")
        expect(page).not_to have_link('Ver Detalhes')
        expect(page).to have_link('Produtos')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).not_to have_link('Cadastrar Produto')
        expect(page).not_to have_link('Criar Lote')
        expect(page).not_to have_link('Lotes Expirados')
    end

    it 'can only see approved lots when searching for empty' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        approved_lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        approved_upcoming_lot = Lot.create!(code: 'CBA123456', start_date: 5.days.from_now, end_date: 9.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        pending_lot = Lot.create!(code: 'AAA123456', start_date: 5.days.from_now, end_date: 9.days.from_now, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :pending)
        canceled_lot = Lot.create!(code: 'BBB123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :canceled)
        closed_lot = Lot.create!(code: 'CCC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                        minimum_bid_difference: 19.9, created_by_user: adm, status: :closed)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: approved_lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        second_product = Product.new(name: 'Cadeira', weight: 3000, width: 70, height: 100, depth: 50,
            category: 'categoria', description: 'cadeira', lot_id: closed_lot.id)
        second_product.image.attach(io: File.open(Rails.root.join('spec/support/Cadeira.jpg')),
            filename: 'Cadeira.jpg', content_type: 'Cadeira.jpg')
        second_product.save!
        third_product = Product.new(name: 'Headphone', weight: 400, width: 20, height: 15, depth: 10,
                            category: 'categoria', description: 'Fone de ouvido ', lot_id: approved_upcoming_lot.id)
        third_product.image.attach(io: File.open(Rails.root.join('spec/support/Headphone.jpg')),
                            filename: 'Headphone.jpg', content_type: 'Headphone.jpg')
        third_product.save!

        #Act
        visit root_path
        fill_in 'Pesquisar Produtos em Lotes', with: ""
        click_on 'Pesquisar'

        #Assert
        expect(current_path).to eq search_path
        expect(page).not_to have_content("Resultado da Busca por: ")
        expect(page).to have_content("#{approved_lot.code}")
        expect(page).to have_content("#{approved_upcoming_lot.code}")
        expect(page).not_to have_content("#{pending_lot.code}")
        expect(page).not_to have_content("#{canceled_lot.code}")
        expect(page).not_to have_content("#{closed_lot.code}")
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).to have_selector("img[src$='Headphone.jpg']")
        expect(page).not_to have_selector("img[src$='Cadeira.jpg']")
        expect(page).to have_link('Ver Detalhes')
        expect(page).to have_link('Produtos')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).not_to have_link('Cadastrar Produto')
        expect(page).not_to have_link('Criar Lote')
        expect(page).not_to have_link('Lotes Expirados')
    end
end