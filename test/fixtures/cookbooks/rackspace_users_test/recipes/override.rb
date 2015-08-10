
# override default data bag and item
node.default['rackspace_users']['data_bag'] = 'common'
node.default['rackspace_users']['data_bag_item'] = 'users'

# declare node tags
node.default['rackspace_users']['node_tags'] = ['web', 'marketing', 'sales']

# Create a user manualy. The recipe should delete the user afterwards.
user_account 'olduser'

sudo 'olduser' do
  user 'olduser'
  runas 'root'
  nopasswd true
end

include_recipe 'rackspace_users'
