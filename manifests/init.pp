class dophonegap (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',
  $group = 'www-data',
  
  # include Eclipse with Android Development Toolkit (ADT)
  $include_adt = false,

  $firewall = true,
  $monitor = true,
  
  # end of class arguments
  # ----------------------
  # begin class

) {

  # install java
  case $operatingsystem {
    centos, redhat, fedora: {
      if ! defined(Package['java-1.7.0-openjdk']) {
        package { 'java-1.7.0-openjdk' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['java-1.7.0-openjdk-devel']) {
        package { 'java-1.7.0-openjdk-devel' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
    }
    ubuntu, debian: {
      if ! defined(Package['openjdk-7-jdk']) {
        package { 'openjdk-7-jdk' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['openjdk-7-jre']) {
        package { 'openjdk-7-jre' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
    }
  }

  # install Ant >= 1.8.2
  case $operatingsystem {
    centos, redhat, fedora: {
      # use puppet module to download and install binary
      class { 'ant':
        version => '1.8.2',
      }
    }
    ubuntu, debian: {
      # use simple package because 12.04 includes 1.8.2
      if ! defined(Package['ant']) {
        package { 'ant' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
    }
  }
  
  # install library pre-reqs
  if ! defined(Package['ncurses-devel']) {
    package { 'ncurses-devel' : ensure => present, before => Anchor['dophonegap-install-ready'] }
  }
  if ! defined(Package['libX11-devel']) {
    package { 'libX11-devel' : ensure => present, before => Anchor['dophonegap-install-ready'] }
  }
  
  anchor { 'dophonegap-install-ready' : }

  if ! defined(Package['phonegap']) {
    package { 'phonegap' :
      provider => 'npm',
      require => Anchor['dophonegap-install-ready'],
    }
  }

  class { 'dophonegap::sdk::android' :
    include_adt => $include_adt,
    require => Anchor['dophonegap-install-ready'],
  }

}