class controller_wallaby ($cloud_role_foreman = "undefined") {

  $cloud_role = $cloud_role_foreman

  $ocatapackages = [ "openstack-utils",

                   ]


     package { $ocatapackages: ensure => "installed" }

  # Install CA
  class {'controller_wallaby::install_ca_cert':}

  # Ceph
  class {'controller_wallaby::ceph':}
  
  # Configure keystone
  class {'controller_wallaby::configure_keystone':}
  
  # Configure glance
  class {'controller_wallaby::configure_glance':}

  # Configure nova
  class {'controller_wallaby::configure_nova':}

## FF for placement in wallaby
  # Configure placement
  class {'controller_wallaby::configure_placement':}
###

  # Configure ec2
  class {'controller_wallaby::configure_ec2':}

  # Configure neutron
  class {'controller_wallaby::configure_neutron':}

  # Configure cinder
  class {'controller_wallaby::configure_cinder':}

  # Configure heat
  class {'controller_wallaby::configure_heat':}

  # Configure horizon
  class {'controller_wallaby::configure_horizon':}

  # Configure Shibboleth if AII and Shibboleth are enabled
  if ($::controller_wallaby::params::enable_aai_ext and $::controller_wallaby::params::enable_shib)  {
    class {'controller_wallaby::configure_shibboleth':}
  }

  # Configure OpenIdc if AII and openidc are enabled
  if ($::controller_wallaby::params::enable_aai_ext and ($::controller_wallaby::params::enable_oidc or $::controller_wallaby::params::enable_infncloud))  {
    class {'controller_wallaby::configure_openidc':}
  }
 
  # Service
  class {'controller_wallaby::service':}

  
  # do passwdless access
  class {'controller_wallaby::pwl_access':}
  
  
  # configure remote syslog
  class {'controller_wallaby::rsyslog':}
  
  

       Class['controller_wallaby::install_ca_cert'] -> Class['controller_wallaby::configure_keystone']
       Class['controller_wallaby::configure_keystone'] -> Class['controller_wallaby::configure_glance']
       Class['controller_wallaby::configure_glance'] -> Class['controller_wallaby::configure_nova']
       Class['controller_wallaby::configure_nova'] -> Class['controller_wallaby::configure_placement']
       Class['controller_wallaby::configure_placement'] -> Class['controller_wallaby::configure_neutron']
       Class['controller_wallaby::configure_neutron'] -> Class['controller_wallaby::configure_cinder']
       Class['controller_wallaby::configure_cinder'] -> Class['controller_wallaby::configure_horizon']
       Class['controller_wallaby::configure_horizon'] -> Class['controller_wallaby::configure_heat']

  }
