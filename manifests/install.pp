class corp104_python3::install inherits corp104_python3 {

  package { $dep_packages: ensure => present }

  $python_install_source = "https://www.python.org/ftp/python/${corp104_python3::python_version}/Python-${corp104_python3::python_version}.tgz"

  if $corp104_python3::http_proxy {
    exec { 'download-source':
      provider => 'shell',
      command  => "curl -x ${corp104_python3::http_proxy} -o ${corp104_python3::python_install_tmp} -O ${python_install_source}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "python3 --version | grep ${corp104_python3::python_version}",
    }
  }
  else {
    exec { 'download-source':
      provider => 'shell',
      command  => "curl -o ${corp104_python3::python_install_tmp} -O ${python_install_source}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "python3 --version | grep ${corp104_python3::python_version}",
    }
  }

  file { 'install-python-script':
    ensure  => file,
    path    => '/tmp/python_install.sh',
    mode    => '0755',
    content => template("${module_name}/install.sh.erb"),
  }

  exec { 'install-python':
    provider => 'shell',
    command  => "/tmp/python_install.sh",
    path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    require  => [ Exec['download-source'], File['install-python-script'] ], 
    unless   => "python3 --version | grep ${corp104_python3::python_version}",
  }
}
