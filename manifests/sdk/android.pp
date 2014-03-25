class dophonegap::sdk::android (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',
  $group = 'www-data',
  
  $install_dir = '/opt',
  $zip_name = 'android-sdk_latest.tgz',
  $expanded_name = 'android-sdk-linux',
  $release = '22.6',
  
  # include Eclipse with Android Development Toolkit (ADT)
  $include_adt = true,

  # end of class arguments
  # ----------------------
  # begin class

) {

  if ($include_adt) {
    # http://dl.google.com/android/adt/adt-bundle-linux-x86_64-20131030.zip
  } else {
    # basic SDK-only install
    exec { 'dophonegap-sdk-android-download-expand-cleanup' :
      path => '/bin:/usr/bin:/sbin:/usr/sbin',
      command => "wget -O ${install_dir}/${zip_name} http://dl.google.com/android/android-sdk_r${release}-linux.tgz; tar -xzvf ${zip_name}; rm ${zip_name}; chmod 0755 ${expanded_name}; chown ${user}:${group} ${expanded_name}",
      cwd => "${install_dir}",
      user => 'root',
      group => 'root',
      creates => '',
    }

    # set the env variables for $user
    $command_bash_include_paths = "\n# setup paths for [Phonegap] Android SDK\nexport PATH=\$PATH:${install_dir}/${expanded_name}/platforms\nexport PATH=\$PATH:${install_dir}/${expanded_name}/tools\nexport PATH=\$PATH:${install_dir}/${expanded_name}/platform-tools"
    concat::fragment { 'dophonegap-android-bashrc-paths':
      target  => "/home/${user}/.bashrc",
      content => $command_bash_include_paths,
      order   => '50',
    }
    
    # symlink 64-bit libGL for Android Emulator client
    file { "${install_dir}/${expanded_name}/tools/lib/libGL.so":
      ensure => 'link',
      target => '/usr/lib64/libGL.so.1',
      require => [Package['mesa-libGL']],
    }

    # download updates for all APIs and extensions
    exec { 'dophonegap-sdk-android-update':
      path => "/bin:/usr/bin:/sbin:/usr/sbin:${install_dir}/${expanded_name}/platforms:${install_dir}/${expanded_name}/tools",
      command => 'android update sdk --no-ui',
      # very long timeout because it can be massive
      timeout => 60*60,
      require => [Exec['dophonegap-sdk-android-download-expand-cleanup']],
    }
  }

}