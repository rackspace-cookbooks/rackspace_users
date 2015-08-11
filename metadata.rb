# Encoding: utf-8
name 'rackspace_users'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides a resource to modify shadow attributes for a user'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'

supports 'centos'
supports 'ubuntu'

depends 'user'
depends 'user_shadow'
depends 'sudo'
