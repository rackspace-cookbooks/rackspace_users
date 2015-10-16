# Encoding: utf-8
name 'rackspace_users'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'A cookbook to manage users from a data bag'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.5'

supports 'centos'
supports 'ubuntu'

depends 'user', '= 0.4.2'
depends 'user_shadow', '= 0.1.4'
depends 'sudo', '= 2.7.2'
