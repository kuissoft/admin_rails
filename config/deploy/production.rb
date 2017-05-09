# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{ra@88.99.188.70}
role :web, %w{ra@88.99.188.70}
role :db,  %w{ra@88.99.188.70}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '88.99.188.70', user: 'ra', roles: %w{web app}, my_property: :my_value
set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: true
}
# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
#server '88.99.188.70',
#   user: 'ra',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'ra', # overrides user setting above
#     keys: %w(/home/leopard/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password),
#     password: '6X6RqjCS3A3MAaWN'
#   }
# setting per server overrides global ssh_options

