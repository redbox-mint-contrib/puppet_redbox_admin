class puppet_redbox_admin::repo ($exec_path = undef, $repo_name = "epel-release",) {
  Exec {
    path      => $exec_path,
    logoutput => true,
  }

  case $::operatingsystem {
    'CentOS' : {
      case $::operatingsystemmajrelease {
        '7'     : { $full_repo_name = "e/${repo_name}-7-5.noarch.rpm" }
        default : { $full_repo_name = "${repo_name}-6-8.noarch.rpm" }
      }

      exec { 'epel_repo':
        command => "rpm -Uv http://download.fedoraproject.org/pub/epel/$::operatingsystemmajrelease/$::architecture/${full_repo_name}",
        unless  => "/bin/rpm -q --quiet ${repo_name}",
      }
    }
  }
}
