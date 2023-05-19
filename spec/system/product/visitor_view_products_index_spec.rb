require 'rails_helper'

describe 'visitor view products index' do
    it 'sucessfully' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        approved_lot = Lot.create!(code: 'ABC123456', start_date: 5.days.ago, end_date: 3.days.from_now, minimum_bid: 49.9,
                                minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        approved_upcoming_lot = Lot.create!(code: 'CBA123456', start_date: 5.days.from_now, end_date: 9.days.from_now, minimum_bid: 49.9,
                                minimum_bid_difference: 19.9, created_by_user: adm, status: :approved)
        pending_lot = Lot.create!(code: 'AAA123456', start_date: 5.days.from_now, end_date: 9.days.from_now, minimum_bid: 49.9,
                                minimum_bid_difference: 19.9, created_by_user: adm, status: :pending)
        closed_lot = Lot.create!(code: 'CCC123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 49.9,
                                minimum_bid_difference: 19.9, created_by_user: adm, status: :closed)

        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: approved_lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        second_product = Product.new(name: 'Headphone', weight: 400, width: 20, height: 15, depth: 10,
                                    category: 'categoria', description: 'Fone de ouvido ', lot_id: approved_upcoming_lot.id)
        second_product.image.attach(io: File.open(Rails.root.join('spec/support/Headphone.jpg')),
                                    filename: 'Headphone.jpg', content_type: 'Headphone.jpg')
        second_product.save!

        third_product = Product.new(name: 'Cadeira', weight: 3000, width: 70, height: 100, depth: 50,
                                    category: 'categoria', description: 'cadeira', lot_id: closed_lot.id)
        third_product.image.attach(io: File.open(Rails.root.join('spec/support/Cadeira.jpg')),
                                    filename: 'Cadeira.jpg', content_type: 'Cadeira.jpg')
        third_product.save!


        fourth_product = Product.new(name: 'Monitor', weight: 400, width: 20, height: 15, depth: 10,
                                    category: 'categoria', description: 'Monitor', lot_id: pending_lot.id)
        fourth_product.image.attach(io: File.open(Rails.root.join('spec/support/Monitor.jpg')),
                                    filename: 'Monitor.jpg', content_type: 'Monitor.jpg')
        fourth_product.save!

        #Act
        visit root_path
        click_on 'Produtos'

        #Assert
        expect(current_path).to eq products_path
        expect(page).to have_content('Produtos')
        expect(page).to have_content("#{product.name}")
        expect(page).to have_content("#{second_product.name}")
        expect(page).not_to have_content("#{third_product.name}")
        expect(page).not_to have_content("#{fourth_product.name}")
        expect(page).not_to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
        expect(page).to have_selector("img[src$='Headphone.jpg']")
        expect(page).not_to have_selector("img[src$='Cadeira.jpg']")
        expect(page).not_to have_selector("img[src$='Monitor.jpg']")
    end


    it 'sucessfully and goes to product lot details' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.days.ago, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400.0 , width: 10.0, height: 16.0, depth: 2.0,
                                category: 'Celular', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        visit products_path
        click_on 'Ver Detalhes'
        click_on  'ABC123456'

        #Assert
        expect(current_path).to eq lot_path(product.lot_id)
        expect(page).to have_content('Detalhes do Lote')
        expect(page).to have_content('Código do Lote: ABC123456')
        expect(page).to have_content("Início do Leilão: #{1.day.ago.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do Leilão: #{3.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta Mínima Inicial: R$2500.0')
        expect(page).to have_content('Diferença Mínima para Lance: R$70.0')
        expect(page).not_to have_button('Aprovar')
        expect(page).not_to have_button('Cancelar')
        expect(page).not_to have_link('Adicionar Produto')
        expect(page).not_to have_link('Editar')
        expect(page).not_to have_content('Status: Aprovado')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end
end