class puppet_redbox_admin::repo (
  $exec_path    = undef,
  $repo_name    = "epel-release",
  $repo_version = "6-8",) {
  $full_repo_name = "${repo_name}-${repo_version}.noarch.rpm"

  Exec {
    path      => $exec_path,
    logoutput => true,
  }

  case $::operatingsystem {
    'CentOS' : {
      exec { 'epel_repo':
        command => "rpm -Uv http://download.fedoraproject.org/pub/epel/$::operatingsystemmajrelease/$::architecture/${full_repo_name}",
        unless  => "/bin/rpm -q --quiet ${repo_name}",
      }
    }
  }
}
