# USER SEED
puts 'Truncate users'
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users RESTART IDENTITY;")

puts 'Seed admin users'

User.create!(name:'Tomáš Staník', phone:'+420606484899', email:'tomas@remoteassistant.me', password:'admin', role:'admin')
User.create!(name:'Tomáš Staník 2', phone:'+421917328431', email:'tomas.stanik@gmail.com', password:'admin', role:'admin')
User.create!(name:'Jiří Kratochvíl', phone:'+420720733688', email:'jiri@remoteassistant.me', password:'admin', role:'admin')
User.create!(name:'Jiří Kratochvíl 2', phone:'+420602302314', email:'kratoj@gmail.com', password:'admin', role:'admin')
User.create!(name:'Jiří Urbášek', phone:'+420604156985', email:'jirka@remoteassistant.me', password:'admin', role:'admin')
User.create!(name:'Jiří Urbášek 2', phone:'+420723385838', email:'jiri.urbasek@gmail.com', password:'admin', role:'admin')
User.create!(name:'Pavel Dostál', phone:'+420773646660', email:'pavel@remoteassistant.me', password:'admin', role:'admin')
User.create!(name:'Pavel Dostál 2', phone:'+4408703976885', email:'pdostal@pdostal.cz', password:'admin', role:'admin')

User.all.each{|u| u.update password: "admin"}


# SETTINGS SEED
puts 'Truncate settings'
ActiveRecord::Base.connection.execute("TRUNCATE TABLE settings RESTART IDENTITY;")
puts 'Seed settings'
Setting.create!([{ name: 'token_expiration_period', value: '300' },
 { name: 'twillio_sms_number', value: '+15736147427' },
 { name: 'twillio_account_sid', value: 'AC32d59eb259a02e9b1f4b88f791cace9a' },
 { name: 'twillio_auth_token', value: '58c70a50ec898f4fa32a00f2514a3ea1' },
 { name: 'force_sms', value: '0' },
 ])