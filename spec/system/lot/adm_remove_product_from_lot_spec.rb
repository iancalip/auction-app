require 'rails_helper'

describe 'Adm removes product from lot' do
    it 'sucessfully' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as(adm)
        visit assign_products_lot_path(lot)
        uncheck "product_#{product.id}"
        click_on 'Salvar'

        #Assert
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content('Lote atualizado com sucesso!')
        expect(page).to have_content('Código do Lote: ABC123456')
        expect(page).to have_content("Início do Leilão: #{1.day.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content("Fim do Leilão: #{3.days.from_now.to_date.strftime("%d/%m/%Y")}")
        expect(page).to have_content('Oferta Mínima Inicial: R$2500.0')
        expect(page).to have_content('Diferença Mínima para Lance: R$70.0')
        expect(page).to have_content('Status: Aguardando Aprovação')
        expect(page).to have_link('Editar')
        expect(page).to have_button('Cancelar')
        expect(page).not_to have_button('Aprovar')
        expect(page).to have_link('Adicionar Produto')
        expect(page).not_to have_content('Iphone')
        expect(page).not_to have_content('Descrição')
        expect(page).not_to have_link('Ver Detalhes')
    end
end