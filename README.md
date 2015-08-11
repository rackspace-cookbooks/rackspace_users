[![Circle CI](https://circleci.com/gh/rackspace-cookbooks/rackspace_users.svg?style=svg)](https://circleci.com/gh/rackspace-cookbooks/rackspace_users)

# rackspace_users

A cookbook to manage users from a data bag.

## Supported Platforms

* Centos 6.6
* Ubuntu 12.04
* Ubuntu 14.04

## Attributes

* `node['rackspace_users']['data_bag']` : Which data bag contains the `users` item. Defaults to `node.chef_environment`
* `node['rackspace_users']['data_bag_item']` : The item that holds the user records. Defaults to `users`
* `node['rackspace_users']['node_tags']` : Array of tags declared by the node calling the recipe. These are used to create users on specific nodes. Defaults to `[]` (empty array).

## Usage

The recipe reads the users from a data bag item. By default, looks for a data bag named after the environment and an item called `users`. This can be overwritten in the consuming cookbook.
After you define the users in the data bag, place a dependency on the rackspace_users cookbook in your cookbook's metadata.rb:
```
depends 'rackspace_users'
```
Then, in your recipe
```
include_recipe 'rackspace_users'
```
### In scope
 * Handle user creation, removal, modification and ssh keys. Leverages the `user_account` resource https://supermarket.chef.io/cookbooks/user
 * Handle account/password expiry information. Leverages the `user_shadow` resource https://supermarket.chef.io/cookbooks/user_shadow
 * Handle "sudo as root" entries. Leverages the `sudo` resource https://supermarket.chef.io/cookbooks/sudo
 * Add user to groups
 * Provides a method of adding users only on specific nodes via tags

### Overview

The recipe logic is driven by user records in the data bag. Data bag name is assumed to be the name of the environment and the item is `users` but it can be overwritten.
An example of a `users` data bag item:
```
{
  "id": "users",
  "testuser": {
  },
  "newuser1": {
    "sudo": {

    }
  },
  "newuser2": {
    "comment": "another new user",
    "uid": 2000,
    "gid": 2000,
    "shell": "/bin/dash",
    "home": "/home/custom_home_directory",
    "password": "$6$bLZbaeySMzRx7P29$cmmF4SbtnXe2Gc1cBc0fpnBUEPxrr8inn6SNq9xpcT7M/vM0FpZmGF105LWrGCValjJMqEtBALZOYayppwJAj/",
    "ssh_keygen": true,
    "ssh_keys": [
      "key1",
      "key2"
    ],
    "groups": [
      "newgroup2"
    ],
    "sp_lstchg": "2015-07-30",
    "sp_expire": "2035-09-30",
    "sp_min": 30,
    "sp_max": 60,
    "sp_inact": 5,
    "sp_warn": 5,
    "sudo": {
      "nopasswd": true,
      "commands": [
        "/etc/init.d/httpd restart",
        "/sbin/iptables"
      ],
      "defaults": [
        "!requiretty",
        "env_reset"
      ]
    }
  },
  "olduser": {
    "action": "remove"
  }
}
```
#### Adding users with basic configuration (no password expiry info, no tags, no sudo)
The basic attribues of a user are named exactly as the parameters used by the `user_account` resource and can be added or omitted completely in which case default values are used. In fact users can be added by simply adding records like:
```
{
  "id": "users",
  "users": {
    "user1": {},
    "user2": {},
    "user3": {}
  }
}
```
Here is an example with some basic attributes:
```
{
  "id": "users",
  "newuser": {
    "comment": "another new user",
    "uid": 2000,
    "gid": 2000,
    "shell": "/bin/dash",
    "home": "/home/custom_home_directory",
    "password": "$6$bLZbaeySMzRx7P29$cmmF4SbtnXe2Gc1cBc0fpnBUEPxrr8inn6SNq9xpcT7M/vM0FpZmGF105LWrGCValjJMqEtBALZOYayppwJAj/",
    "ssh_keygen": true,
    "ssh_keys": [
      "key1",
      "key2"
    ],
    "groups": [
      "newgroup2"
    ],
  }
}
```
The above example also shows the usage of the `groups` array which is a list of OS groups that the user will be granted membership. The group will be created if doesn't exist.

#### Adding a user with password/account expiry information
Password/account expiry information is set by adding attributes in the data bag named exactly as the parameters used by the `user_resource` resource. Example:
```
{
  "id": "users",
  "newuser": {
    "sp_lstchg": "2015-07-30",
    "sp_expire": "2035-09-30",
    "sp_min": 30,
    "sp_max": 60,
    "sp_inact": 5,
    "sp_warn": 5
  }
}
```
#### Tags
User creation on nodes can be controlled by declaring a list of tags on the node consuming the recipe and then subscribing the user to at least one of those tags in the data bag. The user will be created on the node if the user subscribes to at least one of the tags the node declares or if the user doesn't use tags at all. Tag declaration on the node can be done like:

```node.default['rackspace_users']['node_tags'] = ['web', 'admin', 'test']```

And then on the data bag the user can subscribe to one of the tags like:

```
{
  "id": "users",
  "newuser": {
    "node_tags": ["admin"]
  }
}
```
The recipe also creates OS groups named after the tags that the user subscribes and are found in the tags that the node declares. In the case above, the `admin` group will be created and the `newuser` will be granted membership on it. It is worth emphasizing that tags is an optional feature: if the node and user don't use them then the user will simply be created on all nodes consuming the recipe.
