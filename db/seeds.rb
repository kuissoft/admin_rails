User.destroy_all

u1 = User.create!(name: 'Tomas Stanik', phone: '+420 606 484 899', email: 'tomas@remoteassistant.me', password: 'asdfasdf', role: 1)
u2 = User.create!(name: 'Tomas Stanik', phone: '+421 917 328 431', email: 'tomas.stanik@gmail.com', password: 'asdfasdf', role: 1)
u3 = User.create!(name: 'Jakub Arnold', phone: '+420 774 595 676', email: 'jakub@remoteassistant.me', password: 'asdfasdf', role: 1)
u4 = User.create!(name: 'Jana Filova',  phone: '+420 608 166 448', email: 'jana@remoteassistant.me', password: 'asdfasdf', role: 1)
u5 = User.create!(name: 'Jiri Kratochvil',  phone: '+420 720 733 688', email: 'jiri@remoteassistant.me', password: 'asdfasdf', role: 1)

Connection.create!(user: u1, contact: u2, is_pending: false)
Connection.create!(user: u1, contact: u3, is_pending: false)
Connection.create!(user: u1, contact: u4, is_pending: false)
Connection.create!(user: u1, contact: u5, is_pending: false)

Connection.create!(user: u2, contact: u1, is_pending: false)
Connection.create!(user: u2, contact: u3, is_pending: false)
Connection.create!(user: u2, contact: u4, is_pending: false)
Connection.create!(user: u2, contact: u5, is_pending: false)

Connection.create!(user: u3, contact: u1, is_pending: false)
Connection.create!(user: u3, contact: u2, is_pending: false)
Connection.create!(user: u3, contact: u4, is_pending: false)
Connection.create!(user: u3, contact: u5, is_pending: false)

Connection.create!(user: u4, contact: u1, is_pending: false)
Connection.create!(user: u4, contact: u2, is_pending: false)
Connection.create!(user: u4, contact: u3, is_pending: false)
Connection.create!(user: u4, contact: u5, is_pending: false)

Connection.create!(user: u5, contact: u1, is_pending: false)
Connection.create!(user: u5, contact: u2, is_pending: false)
Connection.create!(user: u5, contact: u3, is_pending: false)
Connection.create!(user: u5, contact: u4, is_pending: false)