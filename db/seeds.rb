adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
other_adm = User.create!(name: 'other adm', cpf: '96267093085', email: 'otheradm@leilaodogalpao.com.br', password: 'password')


user = User.create!(name: 'user', cpf: '02324252481', email: 'user@email.com', password: 'password')
other_user = User.create!(name: 'other user', cpf: '64725165026', email: 'otheruser@email.com', password: 'password')


first_ongoing_approved_lot = Lot.create!(code: 'OAL000001', start_date: 1.day.ago, end_date: 5.days.from_now, minimum_bid: 600.0,
                                    minimum_bid_difference: 19.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)
second_ongoing_approved_lot = Lot.create!(code: 'OAL000002', start_date: 2.day.ago, end_date: 2.days.from_now, minimum_bid: 1000.0,
                                    minimum_bid_difference: 99.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)
third_ongoing_approved_lot = Lot.create!(code: 'OAL000003', start_date: 3.day.ago, end_date: 9.days.from_now, minimum_bid: 1600.0,
                                    minimum_bid_difference: 49.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)
fourth_ongoing_approved_lot = Lot.create!(code: 'OAL000004', start_date: 3.day.ago, end_date: 6.days.from_now, minimum_bid: 1200.0,
                                    minimum_bid_difference: 49.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)

ongoing_pending_lot = Lot.create!(code: 'OPL000001', start_date: 1.days.ago, end_date: 10.days.from_now, minimum_bid: 10.0,
                                    minimum_bid_difference: 4.9, created_by_user: adm, status: :pending)
ongoing_canceled_lot = Lot.create!(code: 'OCL000001', start_date: 1.days.ago, end_date: 5.days.from_now, minimum_bid: 180.0,
                                    minimum_bid_difference: 19.9, created_by_user: adm, status: :canceled)


first_upcoming_approved_lot = Lot.create!(code: 'UAL000001', start_date: 3.days.from_now, end_date: 10.days.from_now, minimum_bid: 1600.0,
                                    minimum_bid_difference: 99.9, created_by_user: adm, status: :approved)
second_upcoming_approved_lot = Lot.create!(code: 'UAL000002', start_date: 2.days.from_now, end_date: 8.days.from_now, minimum_bid: 3600.0,
                                    minimum_bid_difference: 99.9, created_by_user: adm, status: :approved)
third_upcoming_approved_lot = Lot.create!(code: 'UAL000003', start_date: 6.days.from_now, end_date: 16.days.from_now, minimum_bid: 900.0,
                                    minimum_bid_difference: 99.9, created_by_user: adm, status: :approved)

upcoming_pending_lot = Lot.create!(code: 'UPL000001', start_date: 3.days.from_now, end_date: 10.days.from_now, minimum_bid: 750,
                                    minimum_bid_difference: 24.9, created_by_user: adm, status: :pending)
upcoming_canceled_lot = Lot.create!(code: 'UCL000001', start_date: 3.days.from_now, end_date: 10.days.from_now, minimum_bid: 100.0,
                                    minimum_bid_difference: 14.9, created_by_user: adm, status: :canceled)


first_expired_approved_lot = Lot.create!(code: 'EAL000001', start_date: 5.days.ago, end_date: 1.day.ago, minimum_bid: 500.0,
                                    minimum_bid_difference: 39.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)
second_expired_approved_lot = Lot.create!(code: 'EAL000002', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 70.0,
                                    minimum_bid_difference: 9.9, created_by_user: adm, status: :approved)

expired_pending_lot = Lot.create!(code: 'EPL000001', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 80.0,
                                    minimum_bid_difference: 9.9, created_by_user: adm, status: :pending)
expired_canceled_lot = Lot.create!(code: 'ECL000001', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 540.0,
                                    minimum_bid_difference: 49.9, created_by_user: adm, status: :canceled)
expired_closed_lot = Lot.create!(code: 'EEL000001', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 350.0,
                                    minimum_bid_difference: 29.9, created_by_user: adm, status: :closed)
second_expired_closed_lot = Lot.create!(code: 'EEL000002', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 850.0,
                                    minimum_bid_difference: 34.9, created_by_user: adm, status: :closed)


file_path = Rails.root.join('spec/support/Cadeira_Gamer.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Cadeira_Gamer.jpg', content_type: 'image/jpg' }

Product.create!(
    name: 'Cadeira Gamer',
    weight: 20000.0,
    width: 70.0,
    height: 150.0,
    depth: 70.0,
    category: 'Gaming',
    description: 'Confortável cadeira gamer',
    lot_id: first_expired_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Cadeira.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Cadeira.jpg', content_type: 'image/jpg' }

Product.create!(
    name: 'Cadeira',
    weight: 15000.0,
    width: 60.0,
    height: 140.0,
    depth: 60.0,
    category: 'Mobiliário',
    description: 'Cadeira confortável para escritório',
    lot_id: second_expired_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/CPU.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'CPU.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'CPU',
    weight: 10000.0,
    width: 20.0,
    height: 20.0,
    depth: 40.0,
    category: 'Informática',
    description: 'CPU de alto desempenho',
    lot_id: expired_closed_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Headphone.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Headphone.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Headphone',
    weight: 500.0,
    width: 16.0,
    height: 18.0,
    depth: 8.0,
    category: 'Eletrônicos',
    description: 'Headphone com excelente qualidade de som',
    lot_id: first_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Iphone.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Iphone.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Iphone',
    weight: 174.0,
    width: 7.6,
    height: 15.4,
    depth: 0.8,
    category: 'Eletrônicos',
    description: 'Iphone de última geração',
    lot_id: first_upcoming_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/JBL.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'JBL.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'JBL Speaker',
    weight: 2000.0,
    width: 10.0,
    height: 10.0,
    depth: 10.0,
    category: 'Eletrônicos',
    description: 'Caixa de som JBL com ótima qualidade de som',
    lot_id: upcoming_pending_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Monitor.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Monitor.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Monitor',
    weight: 3500.0,
    width: 50.0,
    height: 35.0,
    depth: 20.0,
    category: 'Informática',
    description: 'Monitor de alta definição',
    lot_id: upcoming_pending_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Mouse.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Mouse.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Mouse',
    weight: 100.0,
    width: 7.0,
    height: 4.0,
    depth: 13.0,
    category: 'Informática',
    description: 'Mouse ergonômico',
    lot_id: first_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Oculos_de_Sol.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Oculos_de_Sol.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Óculos de Sol',
    weight: 50.0,
    width: 15.0,
    height: 5.0,
    depth: 15.0,
    category: 'Moda',
    description: 'Óculos de sol estiloso',
    lot_id: ongoing_pending_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Teclado_LOL.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Teclado_LOL.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Teclado LOL',
    weight: 1500.0,
    width: 45.0,
    height: 3.0,
    depth: 15.0,
    category: 'Gaming',
    description: 'Teclado temático do League of Legends',
    lot_id: first_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Mesa_de_Jantar.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Mesa_de_Jantar.jpg', content_type: 'image/jpg' }

Product.create!(
    name: 'Mesa de Jantar',
    weight: 50000.0,
    width: 160.0,
    height: 100.0,
    depth: 80.0,
    category: 'Mobiliário',
    description: 'Mesa de Jantar em madeira maciça',
    lot_id: second_expired_closed_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Notebook.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Notebook.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'Notebook',
    weight: 1200.0,
    width: 30.0,
    height: 2.0,
    depth: 20.0,
    category: 'Eletrônicos',
    description: 'Notebook com processador de última geração e alta performance',
    lot_id: second_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Playstation.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Playstation.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'Playstation',
    weight: 3200.0,
    width: 26.5,
    height: 39.0,
    depth: 10.4,
    category: 'Eletrônicos',
    description: 'Console Playstation, última geração',
    lot_id: third_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/ControlePS5.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'ControlePS5.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Controle PS5',
    weight: 280.0,
    width: 16.0,
    height: 5.2,
    depth: 9.9,
    category: 'Eletrônicos',
    description: 'Controle para Playstation 5, sem fio, com touchpad',
    lot_id: third_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Oculus.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Oculus.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'Oculus',
    weight: 470.0,
    width: 19.1,
    height: 8.3,
    depth: 21.5,
    category: 'Eletrônicos',
    description: 'Óculos de realidade virtual, modelo Oculus',
    lot_id: fourth_ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/TV.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'TV.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'TV',
    weight: 8000.0,
    width: 101.0,
    height: 58.7,
    depth: 7.9,
    category: 'Eletrônicos',
    description: 'Televisão de alta definição, tela grande',
    lot_id: second_upcoming_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Robo.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Robo.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'Robo',
    weight: 3000.0,
    width: 30.0,
    height: 50.0,
    depth: 30.0,
    category: 'Eletrônicos',
    description: 'Robô de última geração com inteligência artificial avançada',
    lot_id: third_upcoming_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Airfryer.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Airfryer.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'Airfryer',
    weight: 5000.0,
    width: 30.0,
    height: 30.0,
    depth: 30.0,
    category: 'Cozinha',
    description: 'Descrição da Airfryer',
    lot_id: nil,
    image: image
)

file_path = Rails.root.join('spec/support/Geladeira.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Geladeira.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'Geladeira',
    weight: 70000.0,
    width: 70.0,
    height: 180.0,
    depth: 70.0,
    category: 'Eletrodomésticos',
    description: 'Descrição da Geladeira',
    lot_id: nil,
    image: image
)


Bid.create!(user_id: other_user.id, lot_id: first_ongoing_approved_lot.id, amount: 600)
Bid.create!(user_id: user.id, lot_id: first_ongoing_approved_lot.id, amount: 640)
Bid.create!(user_id: other_user.id, lot_id: first_ongoing_approved_lot.id, amount: 680)

Bid.create!(user_id: user.id, lot_id: second_ongoing_approved_lot.id, amount: 1000)
Bid.create!(user_id: other_user.id, lot_id: second_ongoing_approved_lot.id, amount: 1100)
Bid.create!(user_id: user.id, lot_id: second_ongoing_approved_lot.id, amount: 1300)

Bid.create!(user_id: other_user.id, lot_id: third_ongoing_approved_lot.id, amount: 1600)
Bid.create!(user_id: other_user.id, lot_id: third_ongoing_approved_lot.id, amount: 1800)
Bid.create!(user_id: user.id, lot_id: third_ongoing_approved_lot.id, amount: 2000)

Bid.create!(user_id: user.id, lot_id: fourth_ongoing_approved_lot.id, amount: 1200)
Bid.create!(user_id: user.id, lot_id: fourth_ongoing_approved_lot.id, amount: 1250)
Bid.create!(user_id: other_user.id, lot_id: fourth_ongoing_approved_lot.id, amount: 1300)

Bid.create!(user_id: user.id, lot_id: expired_closed_lot.id, amount: 350)
Bid.create!(user_id: other_user.id, lot_id: expired_closed_lot.id, amount: 400)
Bid.create!(user_id: user.id, lot_id: expired_closed_lot.id, amount: 500)

Bid.create!(user_id: user.id, lot_id: first_expired_approved_lot.id, amount: 500)
Bid.create!(user_id: other_user.id, lot_id: first_expired_approved_lot.id, amount: 540)
Bid.create!(user_id: user.id, lot_id: first_expired_approved_lot.id, amount: 600)

Bid.create!(user_id: user.id, lot_id: second_expired_closed_lot.id, amount: 850)
Bid.create!(user_id: other_user.id, lot_id: second_expired_closed_lot.id, amount: 885)
Bid.create!(user_id: user.id, lot_id: second_expired_closed_lot.id, amount: 920)
Bid.create!(user_id: other_user.id, lot_id: second_expired_closed_lot.id, amount: 1000)


Question.create!(user_id: user.id, lot_id: first_ongoing_approved_lot.id, content: 'Quantos dias após o encerramento do lote serão enviados os produtos?')
Answer.create!(user_id: adm.id, question_id: Question.last.id, content: 'Três dias úteis após o encerramento do lote.')

Question.create!(user_id: other_user.id, lot_id: first_upcoming_approved_lot.id, content: 'O produto é novo?')
Answer.create!(user_id: other_adm.id, question_id: Question.last.id, content: 'Sim e ainda contém uma garantia de um ano.')

Question.create!(user_id: user.id, lot_id: third_ongoing_approved_lot.id, content: 'Vêm com dois controles entao?')

