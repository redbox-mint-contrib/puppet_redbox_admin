# ReDBox Admin - Puppet Manifest

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Installing](#installing)
3. [Post-installation](#post-installation)


## Overview

Puppet redbox admin deploys nodejs, npm (including sails and forever) and redbox admin rpm. 
This manifest will also install elasticsearch and logstash which are core components of this admin interface's log viewing feature.


## Requirements

* Installation of this module at your OS's puppet module directory (e.g. CentOS: /usr/share/puppet/modues/). Consult the puppet documentation specific to your OS.

* Installation of the following puppet modules:

`puppet module install elasticsearch-elasticsearch --version 0.4.0`
`puppet module install elasticsearch-logstash --version 0.5.1` 
`puppet module install maestrodev-wget --version 1.5.6`

## Installing

`puppet apply -e "class {'puppet_redbox_admin':}"`

## Post-installation

### Starting the service

`service redbox-admin start`

### Making the Admin available to the world

If you are installing the admin interface behind an HTTP proxy, '/redbox-admin' needs to be manually added to the proxy configuration. If you plan on installing the admin interface after applying [ReDBox's puppet manifests](https://github.com/redbox-mint-contrib/puppet-redbox), just add the '/redbox-admin' on the list of 'proxy' entries in your Hiera configuration. Make sure you have set the appropriate security configuration before making the admin interface publicly available.