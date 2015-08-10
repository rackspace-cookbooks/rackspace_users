# Set default values for data bag and item containing users.
# These can be overriden in the consuming cookbook.
default['rackspace_users']['data_bag'] = node.chef_environment
default['rackspace_users']['data_bag_item'] = 'users'

# Tags can be used to create users on specific nodes.
# Declare that the node is not tagged by default.
# This can be overriden in the consuming cookbook.
default['rackspace_users']['node_tags'] = []
