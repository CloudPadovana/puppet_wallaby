class compute_wallaby::systemsetting {

# inherits compute_wallaby::params {

include compute_wallaby::params

  # disable SELinux
  exec { "setenforce 0":
           path => "/bin:/sbin:/usr/bin:/usr/sbin",
           onlyif => "which setenforce && getenforce | grep Enforcing",
       }

  # setup sysctl

#  Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }
#  Sysctl {
#          notify      => Exec["load-sysctl"],
#          #require     => Class['compute_wallaby::libvirt'],
#         }

#   $my_sysctl_settings = {
#                          "net.ipv4.conf.all.rp_filter"     => { value => "0" },
#                          "net.ipv4.conf.default.rp_filter" => { value => "0" },
#                          "net.bridge.bridge-nf-call-arptables" => { value => "1" },
#                          "net.bridge.bridge-nf-call-iptables" => { value => "1" },
#                          "net.bridge.bridge-nf-call-ip6tables" => { value => "1" }
#                          }
#

   sysctl { "net.ipv4.conf.all.rp_filter" : 
              ensure => present,
              value  => "0",
   }
   
   sysctl { "net.ipv4.conf.default.rp_filter" : 
              ensure => present,
              value  => "0",
   }

   sysctl { "net.bridge.bridge-nf-call-arptables" : 
              ensure => present,
              value  => "1",
   }

   sysctl { "net.bridge.bridge-nf-call-iptables" : 
              ensure => present,
              value  => "1",
   }

   sysctl { "net.bridge.bridge-nf-call-ip6tables" : 
              ensure => present,
              value  => "1",
   }

#   create_resources(sysctl::value,$my_sysctl_settings)

   exec { load-sysctl:
            command     => "/sbin/sysctl -p /etc/sysctl.conf",
            refreshonly => true
        }

   file {'INFN-CA.pem':
             source      => 'puppet:///modules/compute_wallaby/INFN-CA.pem',
             path        => '/etc/grid-security/certificates/INFN-CA.pem',
        }

   file {'CloudVenetoCAs.pem':
             source      => 'puppet:///modules/compute_wallaby/CloudVenetoCAs.pem',
             path        => '/etc/grid-security/certificates/CloudVenetoCAs.pem',
        }



   package { "ca_TERENA-SSL-CA-3":
             source   => "https://artifacts.pd.infn.it/packages/CAP/misc/CentOS8/noarch/ca_TERENA-SSL-CA-3-1.0-2.el8.noarch.rpm",
             provider => "rpm",
        }
}
