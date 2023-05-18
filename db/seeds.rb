adm = User.create!(name: 'adm', cpf: '51959723030', email: 'adm@leilaodogalpao.com.br', password: 'password')
other_adm = User.create!(name: 'other adm', cpf: '96267093085', email: 'otheradm@leilaodogalpao.com.br', password: 'password')


user = User.create!(name: 'user', cpf: '02324252481', email: 'user@email.com', password: 'password')
other_user = User.create!(name: 'other user', cpf: '64725165026', email: 'otheruser@email.com', password: 'password')


ongoing_approved_lot = Lot.create!(code: 'AAA123456', start_date: 1.day.ago, end_date: 5.days.from_now, minimum_bid: 600.0,
                                    minimum_bid_difference: 19.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)
ongoing_pending_lot = Lot.create!(code: 'BBB123456', start_date: 1.days.ago, end_date: 10.days.from_now, minimum_bid: 10.0,
                                    minimum_bid_difference: 4.9, created_by_user: adm, status: :pending)
ongoing_canceled_lot = Lot.create!(code: 'CCC123456', start_date: 1.days.ago, end_date: 5.days.from_now, minimum_bid: 180.0,
                                    minimum_bid_difference: 19.9, created_by_user: adm, status: :canceled)
upcoming_approved_lot = Lot.create!(code: 'DDD123456', start_date: 3.days.from_now, end_date: 10.days.from_now, minimum_bid: 1600.0,
                                    minimum_bid_difference: 99.9, created_by_user: adm, status: :approved)
upcomming_pending_lot = Lot.create!(code: 'EEE123456', start_date: 3.days.from_now, end_date: 10.days.from_now, minimum_bid: 750,
                                    minimum_bid_difference: 24.9, created_by_user: adm, status: :pending)
upcoming_canceled_lot = Lot.create!(code: 'FFF123456', start_date: 3.days.from_now, end_date: 10.days.from_now, minimum_bid: 100.0,
                                    minimum_bid_difference: 14.9, created_by_user: adm, status: :canceled)
expired_approved_lot = Lot.create!(code: 'GGG123456', start_date: 5.days.ago, end_date: 1.day.ago, minimum_bid: 500.0,
                                    minimum_bid_difference: 39.9, created_by_user: adm, approved_by_user: other_adm, status: :approved)
other_expired_approved_lot = Lot.create!(code: 'HHH123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 70.0,
                                    minimum_bid_difference: 9.9, created_by_user: adm, status: :approved)
expired_pending_lot = Lot.create!(code: 'III123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 80.0,
                                    minimum_bid_difference: 9.9, created_by_user: adm, status: :pending)
expired_canceled_lot = Lot.create!(code: 'JJJ123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 540.0,
                                    minimum_bid_difference: 49.9, created_by_user: adm, status: :canceled)
expired_closed_lot = Lot.create!(code: 'MMM123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 350.0,
                                    minimum_bid_difference: 29.9, created_by_user: adm, status: :closed)
other_expired_closed_lot = Lot.create!(code: 'NNN123456', start_date: 5.days.ago, end_date: 3.days.ago, minimum_bid: 850.0,
                                    minimum_bid_difference: 34.9, created_by_user: adm, status: :closed)


file_path = Rails.root.join('spec/support/Cadeira_Gamer.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Cadeira_Gamer.jpg', content_type: 'image/jpg' }

Product.create!(
    name: 'Cadeira Gamer',
    weight: 20.0,
    width: 70.0,
    height: 150.0,
    depth: 70.0,
    category: 'Gaming',
    description: 'Confortável cadeira gamer',
    lot_id: expired_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Cadeira.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Cadeira.jpg', content_type: 'image/jpg' }

Product.create!(
  name: 'Cadeira',
  weight: 15.0,
  width: 60.0,
  height: 140.0,
  depth: 60.0,
  category: 'Mobiliário',
  description: 'Cadeira confortável para escritório',
  lot_id: other_expired_approved_lot.id,
  image: image
)

file_path = Rails.root.join('spec/support/CPU.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'CPU.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'CPU',
    weight: 10.0,
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
    weight: 0.5,
    width: 16.0,
    height: 18.0,
    depth: 8.0,
    category: 'Eletrônicos',
    description: 'Headphone com excelente qualidade de som',
    lot_id: ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Iphone.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Iphone.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Iphone',
    weight: 0.174,
    width: 7.6,
    height: 15.4,
    depth: 0.8,
    category: 'Eletrônicos',
    description: 'Iphone de última geração',
    lot_id: upcoming_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/JBL.jpeg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'JBL.jpeg', content_type: 'image/jpeg' }
Product.create!(
    name: 'JBL Speaker',
    weight: 2.0,
    width: 10.0,
    height: 10.0,
    depth: 10.0,
    category: 'Eletrônicos',
    description: 'Caixa de som JBL com ótima qualidade de som',
    lot_id: upcomming_pending_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Monitor.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Monitor.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Monitor',
    weight: 3.5,
    width: 50.0,
    height: 35.0,
    depth: 20.0,
    category: 'Informática',
    description: 'Monitor de alta definição',
    lot_id: upcomming_pending_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Mouse.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Mouse.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Mouse',
    weight: 0.1,
    width: 7.0,
    height: 4.0,
    depth: 13.0,
    category: 'Informática',
    description: 'Mouse ergonômico',
    lot_id: ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Oculos_de_Sol.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Oculos_de_Sol.jpg', content_type: 'image/jpg' }
Product.create!(
    name: 'Óculos de Sol',
    weight: 0.05,
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
    weight: 1.5,
    width: 45.0,
    height: 3.0,
    depth: 15.0,
    category: 'Gaming',
    description: 'Teclado temático do League of Legends',
    lot_id: ongoing_approved_lot.id,
    image: image
)

file_path = Rails.root.join('spec/support/Mesa_de_Jantar.jpg')
image_file = File.open(file_path)
image = { io: image_file, filename: 'Mesa_de_Jantar.jpg', content_type: 'image/jpg' }

Product.create!(
    name: 'Mesa de Jantar',
    weight: 50.0,
    width: 160.0,
    height: 100.0,
    depth: 80.0,
    category: 'Mobiliário',
    description: 'Mesa de Jantar em madeira maciça',
    lot_id: other_expired_closed_lot.id,
    image: image
)


Bid.create!(user_id: user.id, lot_id: ongoing_approved_lot.id, amount: 600)
Bid.create!(user_id: other_user.id, lot_id: ongoing_approved_lot.id, amount: 620)
Bid.create!(user_id: user.id, lot_id: ongoing_approved_lot.id, amount: 640)
Bid.create!(user_id: other_user.id, lot_id: ongoing_approved_lot.id, amount: 680)

Bid.create!(user_id: user.id, lot_id: expired_closed_lot.id, amount: 350)
Bid.create!(user_id: other_user.id, lot_id: expired_closed_lot.id, amount: 400)
Bid.create!(user_id: user.id, lot_id: expired_closed_lot.id, amount: 430)

Bid.create!(user_id: user.id, lot_id: expired_approved_lot.id, amount: 500)
Bid.create!(user_id: other_user.id, lot_id: expired_approved_lot.id, amount: 540)
Bid.create!(user_id: user.id, lot_id: expired_approved_lot.id, amount: 600)

Bid.create!(user_id: user.id, lot_id: other_expired_closed_lot.id, amount: 850)
Bid.create!(user_id: other_user.id, lot_id: other_expired_closed_lot.id, amount: 885)
Bid.create!(user_id: user.id, lot_id: other_expired_closed_lot.id, amount: 920)
Bid.create!(user_id: other_user.id, lot_id: other_expired_closed_lot.id, amount: 1000)