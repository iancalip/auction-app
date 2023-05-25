require 'rails_helper'

describe 'Adm answer users' do
    it 'sucessfully' do
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
        question = Question.create!(user_id: user.id, lot_id: lot.id, content: 'Data de envio?')

        #Act
        login_as adm
        visit lot_path(lot)
        fill_in 'answer_content', with: '3 dias úteis após encerramento do leilão.'
        click_on 'Responder'

        #Arrange
        expect(page).to have_content('Dúvidas:')
        expect(page).to have_content('Data de envio?')
        expect(page).to have_field('answer_content', placeholder: 'Digite sua resposta aqui')
        expect(page).to have_button('Responder')
        expect(page).to have_button('Ocultar')
        expect(page).to have_content('LeilON:')
        expect(page).to have_content('3 dias úteis após encerramento do leilão.')
        expect(page).not_to have_content('Faça uma Pergunta:')
        expect(page).not_to have_field('Digite sua pergunta aqui')
        expect(page).not_to have_button('Enviar Pergunta')
    end
end