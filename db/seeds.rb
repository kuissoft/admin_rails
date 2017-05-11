# USER SEED
# puts 'Truncate users'
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users RESTART IDENTITY;")

# puts 'Seed admin users'
User.create!(name:'Tomáš Staník', phone:'+420606484899', email:'tomas@remoteassistant.me', password:'admin', role:'admin')
User.create!(name:'Tomáš Staník (Operátor)', phone:'+421917328431', email:'tomas.stanik@gmail.com', password:'admin', role:'operator')
User.create!(name:'Róbert Tarabčák', phone:'+421902310128', email:'tarabcakr@gmail.com', password:'admin', role:'admin')
User.create!(name:'Róbert Tarabčák (Operátor)', email:'tarabcak.r@gmail.com', password:'admin', role:'operator')
User.create!(name:'Michal Maxo Maxian (Operátor)', phone:'+421903740599', email:'misko.maxian@gmail.com', password:'admin', role:'operator')

User.all.each{|u| u.update password: "admin"}


# SETTINGS SEED
# puts 'Truncate settings'
ActiveRecord::Base.connection.execute("TRUNCATE TABLE settings RESTART IDENTITY;")

# puts 'Seed settings'
Setting.create!([
	{ name: 'token_expiration_period', value: '300' },
	{ name: 'twillio_sms_number', value: '+17543336218' },
	{ name: 'twillio_account_sid', value: 'ACbd4ca1c6faef0b939121ae2d4067fb5b' },
	{ name: 'twillio_auth_token', value: 'de9fd353673920cec688ae3bf7efd53c' },
	{ name: 'force_sms', value: '0' },
])
