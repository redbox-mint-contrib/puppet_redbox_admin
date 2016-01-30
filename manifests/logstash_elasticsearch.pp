# Copyright (C) 2014 Queensland Cyber Infrastructure Foundation (http://www.qcif.edu.au/)
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program; if not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# == Class: puppet_redbox_admin::logstash_elasticsearch
#
# === Authors
#
# Shilo Banihit
#
include wget

class puppet_redbox_admin::logstash_elasticsearch (
  $clusterid            = 'es-cluster-main',
  $nodeid               = 'es-node-main',
  $elasticsearch_config = hiera_hash(elasticsearch, {
    version => '1.1.1-1',
  }
  ),
  $logstash_config      = hiera_hash(logstash, {
    version => '1.4.2-1_2c0f5a1',
  }
  )) {
  case $::operatingsystem {
    'CentOS' : {
      case $::operatingsystemmajrelease {
        '7'     : { $elasticsearch_service_name = "elasticsearch-main" }
        default : { $elasticsearch_service_name = "elasticsearch" }
      }
    }
    default  : {
      $elasticsearch_service_name = "elasticsearch"
    }
  }

  class { 'puppet_common::java':
  }
  class { 'elasticsearch':
    version => $elasticsearch_config[version],
    config  => {
      'cluster.name' => $clusterid,
      'node.name'    => $nodeid,
      'discovery'    => {
        'zen'          => {
          'ping'         => {
            'multicast'    => {
              'enabled'      => 'false'
            }
          }
        }
      }
    }
    ,
    datadir => '/opt/elasticsearch/data',
    require => Class['Puppet_common::Java'],
  } ->
  file { "elasticsearch - datadir":
    ensure  => directory,
    path    => "/opt/elasticsearch/",
    owner   => "elasticsearch",
    group   => "elasticsearch",
    recurse => true
  } ->
  file { "elasticsearch - main dir":
    ensure  => directory,
    path    => "/opt/elasticsearch/data",
    owner   => "elasticsearch",
    group   => "elasticsearch",
    recurse => true
  } -> file { "elasticsearch - main elasticsesarch dir":
    ensure  => directory,
    path    => "/opt/elasticsearch/data/elasticsearch",
    owner   => "elasticsearch",
    group   => "elasticsearch",
    recurse => true
  } ->
  file { "elasticsearch - /var/lib/elasticsearch/elasticsearch":
    ensure => link,
    path   => "/var/lib/elasticsearch/elasticsearch",
    target => "/opt/elasticsearch/data/elasticsearch"
  } ->
  elasticsearch::instance { 'main': } ->
  class { 'logstash': version => $logstash_config[version] } ->
  exec { "Logstash - stopping": command => "/sbin/service logstash stop" } ->
  exec { "Elasticsearch - stopping": command => "/sbin/service elasticsearch stop" } ->
  exec { "Elasticsearch - replace config file with generated one": command => "/bin/cp /etc/elasticsearch/main/elasticsearch.yml /etc/elasticsearch/ && /bin/cp /etc/elasticsearch/main/logging.yml /etc/elasticsearch/" 
  } ->
  file { "logstash - /opt/redbox/home":
    path   => "/opt/redbox/home",
    mode   => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/redbox/home/logs":
    path   => "/opt/redbox/home/logs",
    mode   => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/mint/home":
    path   => "/opt/mint/home",
    mode   => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/mint/home/logs/":
    path   => "/opt/mint/home/logs",
    mode   => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/harvester/":
    path   => "/opt/harvester",
    mode   => "u+rwx,g+rwx,o+rx"
  }
  file { "logstash - /opt/harvester/.json-harvester-manager-production/":
    path   => "/opt/harvester/.json-harvester-manager-production",
    mode   => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/harvester/.json-harvester-manager-production/logs/":
    path   => "/opt/harvester/.json-harvester-manager-production/logs",
    mode   => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /etc/logstash/conf.d/logstash.conf":
    path   => '/etc/logstash/conf.d/logstash.conf',
    ensure => absent
  } ->
  wget::fetch { "Download Logstash config":
    source      => 'https://raw.githubusercontent.com/redbox-mint-contrib/redbox-admin/master/logstash/logstash-redbox-es-prod.conf',
    destination => '/etc/logstash/conf.d/logstash-redbox-es-prod.conf',
    timeout     => 0,
    verbose     => false,
  } ->
  file { "logstash - parent":
    ensure => directory,
    path   => "/opt/logstash",
    owner  => "logstash",
    group  => "logstash"
  } ->
  file { "logstash - since db":
    ensure => directory,
    path   => "/opt/logstash/since",
    owner  => "logstash",
    group  => "logstash"
  } ->
  exec { "Elasticsearch - starting": command => "/sbin/chkconfig ${elasticsearch_service_name} on", } ->
  service { 'logstash - es':
    name   => "elasticsearch",
    ensure => "running",
    enable => true,
  } ->
  exec { "Logstash - chkconfig": command => "/sbin/chkconfig logstash on", } ->
  exec { "Logstash - starting": command => "/sbin/service logstash start" }
}
