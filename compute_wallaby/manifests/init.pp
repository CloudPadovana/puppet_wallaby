class compute_wallaby ($cloud_role_foreman = "undefined") { 

  $cloud_role = $cloud_role_foreman  

  # system check setting (network, selinux, CA files)
    class {'compute_wallaby::systemsetting':}

  # stop services 
    class {'compute_wallaby::stopservices':}

  # install
    class {'compute_wallaby::install':}

  # setup firewall
    class {'compute_wallaby::firewall':}

  # setup bacula
    class {'compute_wallaby::bacula':}
  
  # setup libvirt
    class {'compute_wallaby::libvirt':}

  # setup ceph
    class {'compute_wallaby::ceph':}

  # setup rsyslog
    class {'compute_wallaby::rsyslog':}

  # service
    class {'compute_wallaby::service':}

  # install and configure nova
     class {'compute_wallaby::nova':}

  # install and configure neutron
     class {'compute_wallaby::neutron':}

  # nagios settings
     class {'compute_wallaby::nagiossetting':}

  # do passwdless access
      class {'compute_wallaby::pwl_access':}

    # configure collectd
      class {'compute_wallaby::collectd':}


# execution order
             Class['compute_wallaby::firewall'] -> Class['compute_wallaby::systemsetting']
             Class['compute_wallaby::systemsetting'] -> Class['compute_wallaby::stopservices']
             Class['compute_wallaby::stopservices'] -> Class['compute_wallaby::install']
             Class['compute_wallaby::install'] -> Class['compute_wallaby::bacula']
             Class['compute_wallaby::bacula'] -> Class['compute_wallaby::nova']
             Class['compute_wallaby::nova'] -> Class['compute_wallaby::libvirt']
             Class['compute_wallaby::libvirt'] -> Class['compute_wallaby::neutron']
             Class['compute_wallaby::neutron'] -> Class['compute_wallaby::ceph']
             Class['compute_wallaby::ceph'] -> Class['compute_wallaby::nagiossetting']
             Class['compute_wallaby::nagiossetting'] -> Class['compute_wallaby::pwl_access']
             Class['compute_wallaby::pwl_access'] -> Class['compute_wallaby::collectd']
             Class['compute_wallaby::collectd'] -> Class['compute_wallaby::service']
################           
}
  
