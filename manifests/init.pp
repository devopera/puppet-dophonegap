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
  
  case $operatingsystem {
    centos, redhat, fedora: {
      # install 64-bit library pre-reqs
      if ! defined(Package['ncurses-devel']) {
        package { 'ncurses-devel' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['libX11-devel']) {
        package { 'libX11-devel' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['mesa-libGL']) {
        package { 'mesa-libGL' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
    
      # install 32-bit library pre-reqs, because SDK (at least <= 19.0.3) is based on 32-bit
      if ! defined(Package['glibc.i686']) {
        package { 'glibc.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['glibc-devel.i686']) {
        package { 'glibc-devel.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['libstdc++.i686']) {
        package { 'libstdc++.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['zlib-devel.i686']) {
        package { 'zlib-devel.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['ncurses-devel.i686']) {
        package { 'ncurses-devel.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['libX11-devel.i686']) {
        package { 'libX11-devel.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['libXrender.i686']) {
        package { 'libXrender.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      if ! defined(Package['libXrandr.i686']) {
        package { 'libXrandr.i686' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
    }
    ubuntu, debian: {
      if ! defined(Package['libgl1-mesa-dev']) {
        package { 'mesa-libGL' : name => 'libgl1-mesa-dev', ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
      #if ! defined(Package['libgl1-mesa-dev:i386']) {
      #  package { 'libgl1-mesa-dev:i386' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      #}
      if ! defined(Package['ia32-libs']) {
        package { 'ia32-libs' : ensure => present, before => Anchor['dophonegap-install-ready'] }
      }
    }
  }

  anchor { 'dophonegap-install-ready' : }

  if ! defined(Package['phonegap']) {
    package { 'phonegap' :
      provider => 'npm',
      require => Anchor['dophonegap-install-ready'],
    }
  }

  class { 'doandroid::sdk' :
    user => $user,
    include_adt => $include_adt,
    require => Anchor['dophonegap-install-ready'],
  }

}
