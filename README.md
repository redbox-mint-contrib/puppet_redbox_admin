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

* Installation of this module at your OS's shared puppet module directory (e.g. CentOS: /usr/share/puppet/modules/). Consult the puppet documentation specific to your OS.

* Installation of [Puppet Common](https://github.com/redbox-mint-contrib/puppet_common) module at your OS's shared puppet module directory.

* Installation of Elasticsearch and Logstash repositories to your package management system. For Debian and RPM-based, [see this page](http://www.elasticsearch.org/blog/apt-and-yum-repositories/). If you plan on installing the admin interface after applying [ReDBox's puppet manifests](https://github.com/redbox-mint-contrib/puppet-redbox), then simply add the repo configuration in your Hiera config:

```
yum_repos:
  - name: 'redbox'
    descr: 'Redbox_repo'
    baseurl: 'http://dev.redboxresearchdata.com.au/yum/snapshots'
    gpgcheck: 0
    enabled: 1
  - name: 'elasticsearch-1.1'
    descr: 'Elasticsearch repository for 1.1.x packages'
    baseurl: 'http://packages.elasticsearch.org/elasticsearch/1.1/centos'
    gpgcheck: 0
    enabled: 1
  - name: 'logstash-1.4'
    descr: 'logstash repository for 1.4.x packages'
    baseurl: 'http://packages.elasticsearch.org/logstash/1.4/centos'
    gpgcheck: 0
    enabled: 1

```

* Installation of the following puppet modules:

```
puppet module install elasticsearch-elasticsearch --version 0.4.0

puppet module install elasticsearch-logstash --version 0.5.1

puppet module install maestrodev-wget --version 1.5.6
```

## Installing

`puppet apply -e "class {'puppet_redbox_admin':}"`

## Post-installation

### Controlling the service

`service redbox-admin [start|stop|restart|status]`

### Making the Admin available to the world

If you are installing the admin interface behind an HTTP proxy, '/redbox-admin' needs to be manually added to the proxy configuration. If you plan on installing the admin interface after applying [ReDBox's puppet manifests](https://github.com/redbox-mint-contrib/puppet-redbox), just add the '/redbox-admin' on the list of 'proxy' entries in your Hiera configuration, like so:

```
proxy:
  - path: '/redbox-admin'
    url: 'http://localhost:9000/redbox-admin'
```

Make sure you have set the appropriate security configuration before making the admin interface publicly available.