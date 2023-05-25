require 'rails_helper'

describe 'User access lot details' do
    it 'and see questions field on approved' do
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

        #Arrange
        expect(page).to have_content('Faça uma Pergunta:')
        expect(page).to have_field('question_content', placeholder: 'Digite sua pergunta aqui')
        expect(page).to have_button('Enviar Pergunta')
    end

    it 'and makes question' do
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
        fill_in'question_content', with: 'Quantos dias para o envio após o lote ser encerrado?'
        click_on 'Enviar Pergunta'

        #Arrange
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content('Pergunta enviada com sucesso!')
        expect(page).to have_content('Dúvidas:')
        expect(page).to have_content('Quantos dias para o envio após o lote ser encerrado?')
        expect(page).to have_content('Faça uma Pergunta:')
        expect(page).to have_field('question_content', placeholder: 'Digite sua pergunta aqui')
        expect(page).to have_button('Enviar Pergunta')
        expect(page).not_to have_button('Ocultar')
    end

    it 'and cant see hidden questions' do
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
        question = Question.create!(user_id: user.id, lot_id: lot.id, content: 'Data de envio?', hidden: true)

        #Act
        login_as user
        visit lot_path(lot)

        #Arrange
        expect(page).not_to have_content('Dúvidas')
        expect(page).not_to have_content('Data de envio?')
        expect(page).to have_content('Faça uma Pergunta:')
        expect(page).to have_field('question_content', placeholder: 'Digite sua pergunta aqui')
        expect(page).to have_button('Enviar Pergunta')
    end

    it 'and cant make questions on a canceled lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :canceled)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)

        #Arrange
        expect(current_path).to eq lot_path(lot)
        expect(page).not_to have_content('Faça uma Pergunta:')
        expect(page).not_to have_field('question_content', placeholder: 'Digite sua pergunta aqui')
        expect(page).not_to have_button('Enviar Pergunta')
    end

    it 'and cant make questions on a closed lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :closed)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)

        #Arrange
        expect(current_path).to eq lot_path(lot)
        expect(page).not_to have_content('Faça uma Pergunta:')
        expect(page).not_to have_field('question_content', placeholder: 'Digite sua pergunta aqui')
        expect(page).not_to have_button('Enviar Pergunta')
    end

    it 'and cant make questions on a pending lot' do
        #Arrange
        adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
        user = User.create!(name: 'user', cpf: '96267093085', email: 'user@email.com.br', password: 'password')
        lot = Lot.create!(code: 'ABC123456', start_date: Date.current, end_date: 3.days.from_now, minimum_bid: 2500.0,
                        minimum_bid_difference: 70.0, created_by_user: adm, status: :pending)
        product = Product.new(name: 'Iphone', weight: 400 , width: 10, height: 16, depth: 2,
                                category: 'categoria', description: 'Descrição', lot_id: lot.id)
        product.image.attach(io: File.open(Rails.root.join('spec/support/Iphone.jpg')),
                                filename: 'Iphone.jpg', content_type: 'Iphone.jpg')
        product.save!

        #Act
        login_as user
        visit lot_path(lot)

        #Arrange
        expect(current_path).to eq root_path
        expect(page).to have_content('Lote indisponível')
        expect(page).not_to have_content('Faça uma Pergunta:')
        expect(page).not_to have_field('question_content', placeholder: 'Digite sua pergunta aqui')
        expect(page).not_to have_button('Enviar Pergunta')
    end
end