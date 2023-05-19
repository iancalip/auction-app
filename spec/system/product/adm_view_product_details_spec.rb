require 'rails_helper'

describe 'adm visit product details' do
    it 'sucessfully and sees Edit button' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        product = Product.new(name: 'Iphone', weight: 400.0 , width: 10.0, height: 16.0, depth: 2.0,
                                category: 'Celular', description: 'Descrição', lot_id: nil)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit root_path
        click_on 'Produtos'
        click_on 'Ver Detalhes'

        #Assert
        expect(current_path).to eq product_path(product)
        expect(page).to have_content('Detalhes do Produto')
        expect(page).to have_content('Nome: Iphone')
        expect(page).to have_content('Peso: 400.0 g')
        expect(page).to have_content('Largura: 10.0 cm')
        expect(page).to have_content('Altura: 16.0 cm')
        expect(page).to have_content('Profundidade: 2.0 cm')
        expect(page).to have_content('Categoria: Celular')
        expect(page).to have_content('Descrição: Descrição')
        expect(page).to have_content('Atualmente no Lote: Nenhum Lote Associado')
        expect(page).to have_link('Editar')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end

    it 'sucessfully and sees products lot code' do
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
        login_as adm
        visit products_path
        click_on 'Ver Detalhes'

        #Assert
        expect(current_path).to eq product_path(product)
        expect(page).to have_content('Detalhes do Produto')
        expect(page).to have_content('Nome: Iphone')
        expect(page).to have_content('Peso: 400.0 g')
        expect(page).to have_content('Largura: 10.0 cm')
        expect(page).to have_content('Altura: 16.0 cm')
        expect(page).to have_content('Profundidade: 2.0 cm')
        expect(page).to have_content('Categoria: Celular')
        expect(page).to have_content('Descrição: Descrição')
        expect(page).to have_content('Atualmente no Lote:')
        expect(page).to have_link("#{product.lot.code}")
        expect(page).to have_link('Editar')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end

    it 'sucessfully and can see products lot code on pending lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.days.ago, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :pending)
        product = Product.new(name: 'Iphone', weight: 400.0 , width: 10.0, height: 16.0, depth: 2.0,
                                category: 'Celular', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit products_path
        click_on 'Ver Detalhes'

        #Assert
        expect(current_path).to eq product_path(product)
        expect(page).to have_content('Detalhes do Produto')
        expect(page).to have_content('Nome: Iphone')
        expect(page).to have_content('Peso: 400.0 g')
        expect(page).to have_content('Largura: 10.0 cm')
        expect(page).to have_content('Altura: 16.0 cm')
        expect(page).to have_content('Profundidade: 2.0 cm')
        expect(page).to have_content('Categoria: Celular')
        expect(page).to have_content('Descrição: Descrição')
        expect(page).to have_content('Atualmente no Lote: ABC123456')
        expect(page).to have_link("#{product.lot.code}")
        expect(page).to have_link('Editar')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end

    it 'sucessfully and goes to product lot details' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.days.ago, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :closed)
        product = Product.new(name: 'Iphone', weight: 400.0 , width: 10.0, height: 16.0, depth: 2.0,
                                category: 'Celular', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as adm
        visit product_path(product)
        click_on "#{product.lot.code}"

        #Assert
        expect(current_path).to eq lot_path(product.lot_id)
        expect(page).to have_content('Detalhes do Lote')
        expect(page).to have_content('Status: Encerrado')
        expect(page).to have_content('Código do Lote: ABC123456')
        expect(page).to have_content("Início do Leilão: #{1.day.ago.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do Leilão: #{3.days.from_now.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta Mínima Inicial: R$2500.0')
        expect(page).to have_content('Diferença Mínima para Lance: R$70.0')
        expect(page).not_to have_button('Aprovar')
        expect(page).to have_button('Cancelar')
        expect(page).not_to have_link('Adicionar Produto')
        expect(page).to have_link('Editar')
        expect(page).not_to have_link('Meus Lotes')
        expect(page).to have_link('Produtos')
        expect(page).to have_selector("img[src$='Iphone.jpg']")
    end
end