User.destroy_all

u1 = User.create!(name: 'Tomas Stanik', phone: '+420 606 484 899', email: 'tomas@remoteassistant.me', password: 'asdfasdf', role: 1)
u2 = User.create!(name: 'Tomas Stanik', phone: '+421 917 328 431', email: 'tomas.stanik@gmail.com', password: 'asdfasdf', role: 1)
u3 = User.create!(name: 'Jakub Arnold', phone: '+420 774 595 676', email: 'jakub@remoteassistant.me', password: 'asdfasdf', role: 1)
u4 = User.create!(name: 'Jana Filova',  phone: '+420 608 166 448', email: 'jana@remoteassistant.me', password: 'asdfasdf', role: 1)

Connection.create!(user: u1, connection: u2, is_pending: false)
Connection.create!(user: u1, connection: u3, is_pending: false)
Connection.create!(user: u1, connection: u4, is_pending: false)

Connection.create!(user: u2, connection: u1, is_pending: false)
Connection.create!(user: u2, connection: u3, is_pending: false)
Connection.create!(user: u2, connection: u4, is_pending: false)

Connection.create!(user: u3, connection: u1, is_pending: false)
Connection.create!(user: u3, connection: u2, is_pending: false)
Connection.create!(user: u3, connection: u4, is_pending: false)

Connection.create!(user: u4, connection: u1, is_pending: false)
Connection.create!(user: u4, connection: u2, is_pending: false)
Connection.create!(user: u4, connection: u3, is_pending: false)
