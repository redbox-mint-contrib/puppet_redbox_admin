# == Class: puppet_redbox_admin
#
# === Authors
#
# Matt Mulholland <matt@redboxresearchdata.com.au>
#
# === Copyright
#
# Copyright (C) 2013 Queensland Cyber Infrastructure Foundation (http://www.qcif.edu.au/)
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
class puppet_redbox_admin (
  $npm       = hiera_hash(npm, {
    version => '1.3.6-5.el6',
  }
  ),
  $nodejs    = hiera_hash(nodejs, {
    version => '0.10.32-1.el6',
  }
  ),
  $exec_path = hiera_array(exec_path, [
    '/usr/local/bin',
    '/opt/local/bin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
    '/usr/local/rvm/gems/ruby-1.9.3-p547/bin']),
  $epel_repo = hiera_hash(epel_repo, {
    name    => "epel-release",
    version => "6-8",
  }
  ),
  $yum_repos = hiera_array(yum_repos, [{
      name     => 'redbox',
      descr    => 'Redbox_repo',
      baseurl  => 'http://dev.redboxresearchdata.com.au/yum/snapshots',
      gpgcheck => 0,
      enabled  => 1
    }
    ]),
  $es_clusterid = 'es-cluster-main',
  $es_nodeid = 'es-node-main',
  ) {
  Package {
    allow_virtual => false, }
  class { 'puppet_redbox_admin::repo':
    exec_path    => $exec_path,
    repo_name    => $epel_repo[name],
    repo_version => $epel_repo[version],
  } ->
  package { 'nodejs': ensure => $nodejs[version], } ~>
  package { 'npm': ensure => $npm[version], } ~>
  puppet_common::add_yum_repo { $yum_repos: exec_path => $exec_path } ~>
  class { 'puppet_redbox_admin::logstash_elasticsearch': clusterid=>$es_clusterid, nodeid=>$es_nodeid} ~>
  package { 'redbox-admin': install_options => ['-v'] }
}
