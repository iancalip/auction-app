require 'rails_helper'
describe 'Visitor try to answer questions' do
    it 'but they are not allowed' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '02324252481', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: 1.day.from_now, end_date: 3.days.from_now, minimum_bid: 49.90,
                        minimum_bid_difference: 19.90, created_by_user: adm, status: :approved)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!
        question = Question.create!(user_id: user.id, lot_id: lot.id, content: 'Data de envio?')

        #Act
        visit lot_path(lot)

        #Assert
        expect(page).not_to have_button('Ocultar')
        expect(page).not_to have_button('Responder')
        expect(page).not_to have_content('Resposta')
        expect(page).not_to have_field('answer_content', placeholder: 'Digite sua resposta aqui')
    end
end