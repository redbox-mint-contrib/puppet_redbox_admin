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
  $elasticsearch_config = hiera_hash(elasticsearch, {
    version => '1.1.1-1'
  }),
  $logstash_config = hiera_hash(logstash, {
    version  => '1.4.2-1_2c0f5a1',
  })
  )
  {
  class { 'elasticsearch':
    version => $elasticsearch_config[version],
    config => {
      'discovery'=> {
        'zen'=> {
          'ping' => {
            'multicast' => {
              'enabled' => 'false'
            }
          }
        }
      }
    }
  } ->
  elasticsearch::instance {'main':
  } ->
  class { 'logstash':
    version => $logstash_config[version]
  } -> 
  file { "logstash - /opt/redbox/home":
    path => "/opt/redbox/home",
    ensure => directory,
    mode => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/redbox/home/logs":
    path => "/opt/redbox/home/logs",
    ensure => directory,
    mode => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/mint/home":
    path => "/opt/mint/home",
    ensure => directory,
    mode => "u+rwx,g+rwx,o+rx"
  } -> 
  file { "logstash - /opt/mint/home/logs/":
    path => "/opt/mint/home/logs",
    ensure => directory,
    mode => "u+rwx,g+rwx,o+rx"
  } ->
  file { "logstash - /opt/harvester/.json-harvester-manager-production/logs/":
    path => "/opt/harvester/.json-harvester-manager-production/logs",
    ensure => directory,
    mode => "u+rwx,g+rwx,o+rx"
  } ->
  exec { "Logstash - stopping":
    command => "/sbin/service logstash stop"
  } ->
  file { "logstash - /etc/logstash/conf.d/logstash.conf": 
    path => '/etc/logstash/conf.d/logstash.conf',
    ensure => absent
  } ->
  wget::fetch { "Download Logstash config":
    source      => 'https://raw.githubusercontent.com/redbox-mint-contrib/redbox-admin/master/logstash/logstash-redbox-es-prod.conf',
    destination => '/etc/logstash/conf.d/logstash-redbox-es-prod.conf',
    timeout     => 0,
    verbose     => false,
  } ->
  service { 'logstash - es':
    name => "elasticsearch",
    ensure => "running"
  } ->
  exec { "Logstash - starting":
    command => "/sbin/service logstash start"
  }
}