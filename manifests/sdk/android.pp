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
    }
    # setup paths for user
    # start here
  }

}