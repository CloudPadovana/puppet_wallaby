class controller_wallaby::configure_neutron inherits controller_wallaby::params {

#
# Questa classe:
# - popola il file /etc/neutron/neutron.conf
# - popola il file /etc/neutron/plugins/ml2/ml2_conf.ini
# - popola il file  /etc/neutron/plugins/ml2/openvswitch_agent.ini
# - popola il file /etc/neutron/l3_agent.ini
# - popola il file /etc/neutron/dhcp_agent.ini
# - popola il file /etc/neutron/metadata_agent.ini
# - Definisce il link /etc/neutron/plugin.ini --> /etc/neutron/plugins/ml2/ml2_conf.ini
# - Modifica il file /etc/sudoers.d/neutron in modo che non venga loggato in /var/log/secure un msg ogni 2 sec
# 

  
 
define do_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/crudini --set ${conf_file} ${section} ${param} \"${value}\"",
                              require     => Package['crudini'],
                              unless      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                  }
       }

define remove_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/crudini --del ${conf_file} ${section} ${param}",
                              require     => Package['crudini'],
                              onlyif      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                   }
       }
                                                                                                                                             
  
# neutron.conf
   controller_wallaby::configure_neutron::do_config { 'neutron_transport_url': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'transport_url', value => $controller_wallaby::params::transport_url, }
   controller_wallaby::configure_neutron::do_config { 'neutron_auth_strategy': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'auth_strategy', value => $controller_wallaby::params::auth_strategy, }
   controller_wallaby::configure_neutron::do_config { 'neutron_core_plugin': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'core_plugin', value => $controller_wallaby::params::neutron_core_plugin, }
   controller_wallaby::configure_neutron::do_config { 'neutron_service_plugins': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'service_plugins', value => $controller_wallaby::params::neutron_service_plugins, }
   controller_wallaby::configure_neutron::do_config { 'neutron_allow_overlapping_ips': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'allow_overlapping_ips', value => $controller_wallaby::params::neutron_allow_overlapping_ips, }
   controller_wallaby::configure_neutron::do_config { 'neutron_notify_nova_on_port_status_changes': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'notify_nova_on_port_status_changes', value => $controller_wallaby::params::neutron_notify_nova_on_port_status_changes, }
   controller_wallaby::configure_neutron::do_config { 'neutron_notify_nova_on_port_data_changes': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'notify_nova_on_port_data_changes', value => $controller_wallaby::params::neutron_notify_nova_on_port_data_changes, }
   controller_wallaby::configure_neutron::do_config { 'neutron_dhcp_agents_per_network': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'dhcp_agents_per_network', value => $controller_wallaby::params::dhcp_agents_per_network, }
   controller_wallaby::configure_neutron::do_config { 'neutron_l3_ha': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'l3_ha', value => $controller_wallaby::params::neutron_l3_ha, }
   controller_wallaby::configure_neutron::do_config { 'neutron_allow_automatic_l3agent_failover': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'allow_automatic_l3agent_failover', value => $controller_wallaby::params::neutron_allow_automatic_l3agent_failover, }
   controller_wallaby::configure_neutron::do_config { 'neutron_max_l3_agents_per_router': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'max_l3_agents_per_router', value => $controller_wallaby::params::neutron_max_l3_agents_per_router, }
       
#MS: The min_l3_agents_per_router configuration option was deprecated in Newton cycle and removed in Ocata       
#   controller_wallaby::configure_neutron::do_config { 'neutron_min_l3_agents_per_router': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'min_l3_agents_per_router', value => $controller_wallaby::params::neutron_min_l3_agents_per_router, }
   controller_wallaby::configure_neutron::do_config { 'neutron_allow_automatic_dhcp_failover': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'allow_automatic_dhcp_failover', value => $controller_wallaby::params::allow_automatic_dhcp_failover, }

   controller_wallaby::configure_neutron::do_config { 'neutron_db': conf_file => '/etc/neutron/neutron.conf', section => 'database', param => 'connection', value => $controller_wallaby::params::neutron_db, }

       controller_wallaby::configure_neutron::do_config { 'neutron_lock_path': conf_file => '/etc/neutron/neutron.conf', section => 'oslo_concurrency', param => 'lock_path', value => $controller_wallaby::params::neutron_lock_path, }
   ##FF in rocky [keystone_authtoken] auth_uri diventa www_authenticate_uri
   #controller_wallaby::configure_neutron::do_config { 'neutron_auth_uri': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_uri', value => $controller_wallaby::params::auth_uri, }   
   controller_wallaby::configure_neutron::do_config { 'neutron_www_authenticate_uri': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $controller_wallaby::params::www_authenticate_uri, }   
   ##FF in rocky [keystone_authtoken] auth_url passa da 35357 a 5000
   controller_wallaby::configure_neutron::do_config { 'neutron_keystone_authtoken_auth_url': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_url', value => $controller_wallaby::params::neutron_keystone_authtoken_auth_url, }
   controller_wallaby::configure_neutron::do_config { 'neutron_auth_type': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_type', value => $controller_wallaby::params::auth_type, }
   controller_wallaby::configure_neutron::do_config { 'neutron_project_domain_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $controller_wallaby::params::project_domain_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_user_domain_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $controller_wallaby::params::user_domain_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_project_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'project_name', value => $controller_wallaby::params::project_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_username': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'username', value => $controller_wallaby::params::neutron_username, }
   controller_wallaby::configure_neutron::do_config { 'neutron_password': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'password', value => $controller_wallaby::params::neutron_password, }
   controller_wallaby::configure_neutron::do_config { 'neutron_cafile': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'cafile', value => $controller_wallaby::params::cafile, }
   controller_wallaby::configure_neutron::do_config { 'neutron_memcached_servers': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $controller_wallaby::params::memcached_servers, }

   ##FF in rocky [nova] auth_url da 35357 diventa 5000
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_auth_url': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'auth_url', value => $controller_wallaby::params::neutron_auth_url, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_auth_type': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'auth_type', value => $controller_wallaby::params::auth_type, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_project_domain_name': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'project_domain_name', value => $controller_wallaby::params::project_domain_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_user_domain_name': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'user_domain_name', value => $controller_wallaby::params::user_domain_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_region_name': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'region_name', value => $controller_wallaby::params::region_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_project_name': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'project_name', value => $controller_wallaby::params::project_name, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_username': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'username', value => $controller_wallaby::params::nova_username, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_password': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'password', value => $controller_wallaby::params::nova_password, }
   controller_wallaby::configure_neutron::do_config { 'neutron_nova_cafile': conf_file => '/etc/neutron/neutron.conf', section => 'nova', param => 'cafile', value => $controller_wallaby::params::cafile, }

#######Proxy headers parsing
controller_wallaby::configure_neutron::do_config { 'neutron_enable_proxy_headers_parsing': conf_file => '/etc/neutron/neutron.conf', section => 'oslo_middleware', param => 'enable_proxy_headers_parsing', value => $controller_wallaby::params::enable_proxy_headers_parsing, }


#
# Setting di quote di default per nuovi progetti, in modo da non dare la possibilita` di creare nuove reti, nuovi
# router
# Quota 0 per FIP
#
   controller_wallaby::configure_neutron::do_config { 'neutron_quota_network': conf_file => '/etc/neutron/neutron.conf', section => 'quotas', param => 'quota_network', value => $controller_wallaby::params::quota_network, }
   controller_wallaby::configure_neutron::do_config { 'neutron_quota_subnet': conf_file => '/etc/neutron/neutron.conf', section => 'quotas', param => 'quota_subnet', value => $controller_wallaby::params::quota_subnet, }
   controller_wallaby::configure_neutron::do_config { 'neutron_quota_port': conf_file => '/etc/neutron/neutron.conf', section => 'quotas', param => 'quota_port', value => $controller_wallaby::params::quota_port, }
   controller_wallaby::configure_neutron::do_config { 'neutron_quota_router': conf_file => '/etc/neutron/neutron.conf', section => 'quotas', param => 'quota_router', value => $controller_wallaby::params::quota_router, }
   controller_wallaby::configure_neutron::do_config { 'neutron_quota_floatingip': conf_file => '/etc/neutron/neutron.conf', section => 'quotas', param => 'quota_floatingip', value => $controller_wallaby::params::quota_floatingip, }

  controller_wallaby::configure_neutron::do_config { 'neutron_rabbit_ha_queues': conf_file => '/etc/neutron/neutron.conf', section => 'oslo_messaging_rabbit', param => 'rabbit_ha_queues', value => $controller_wallaby::params::rabbit_ha_queues, }
  controller_wallaby::configure_neutron::do_config { 'neutron_amqp_durable_queues': conf_file => '/etc/neutron/neutron.conf', section => 'oslo_messaging_rabbit', param => 'amqp_durable_queues', value => $controller_wallaby::params::amqp_durable_queues, }




   # ml2_conf.ini

   controller_wallaby::configure_neutron::do_config { 'ml2_type_drivers': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2', param => 'type_drivers', value => $controller_wallaby::params::ml2_type_drivers, }
   controller_wallaby::configure_neutron::do_config { 'ml2_tenant_network_types': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2', param => 'tenant_network_types', value => $controller_wallaby::params::ml2_tenant_network_types, }
   controller_wallaby::configure_neutron::do_config { 'ml2_mechanism_drivers': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2', param => 'mechanism_drivers', value => $controller_wallaby::params::ml2_mechanism_drivers, }

   controller_wallaby::configure_neutron::do_config { 'ml2_tunnel_id_ranges': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2_type_gre', param => 'tunnel_id_ranges', value => $controller_wallaby::params::ml2_tunnel_id_ranges, }

   controller_wallaby::configure_neutron::do_config { 'ml2_tunnel_types': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'agent', param => 'tunnel_types', value => $controller_wallaby::params::ml2_tunnel_types, }

       controller_wallaby::configure_neutron::do_config { 'ml2_enable_security_group': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'securitygroup', param => 'enable_security_group', value => $controller_wallaby::params::ml2_enable_security_group, }
   controller_wallaby::configure_neutron::do_config { 'ml2_enable_ipset': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'securitygroup', param => 'enable_ipset', value => $controller_wallaby::params::ml2_enable_ipset, }

   controller_wallaby::configure_neutron::do_config { 'ml2_flat_networks': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ml2_type_flat', param => 'flat_networks', value => $controller_wallaby::params::ml2_flat_networks, }

   controller_wallaby::configure_neutron::do_config { 'ml2_local_ip': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'local_ip', value => $controller_wallaby::params::ml2_local_ip, }
   controller_wallaby::configure_neutron::do_config { 'ml2_bridge_mappings': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'bridge_mappings', value => $controller_wallaby::params::ml2_bridge_mappings, }

   
   if $::controller_wallaby::cloud_role == "is_production" { 
     controller_wallaby::configure_neutron::do_config { 'ml2_network_vlan_ranges': conf_file => '/etc/neutron/plugins/ml2/ml2_conf.ini', section => 'ovs', param => 'network_vlan_ranges', value => $controller_wallaby::params::ml2_network_vlan_ranges, }
   }
              
  # openvswitch_agent.ini

   controller_wallaby::configure_neutron::do_config { 'ovs_tunnel_types': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'agent', param => 'tunnel_types', value => $controller_wallaby::params::ml2_tunnel_types, }
   controller_wallaby::configure_neutron::do_config { 'ovs_local_ip': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'local_ip', value => $controller_wallaby::params::ml2_local_ip, }
   ### FF ADDED in  PIKE: A new config option bridge_mac_table_size has been added for Neutron OVS agent. This value will be set on every Open vSwitch bridge managed by the openvswitch-neutron-agent in other_config:mac-table-size column in ovsdb. Default value for this new option is set to 50000 and it should be enough for most systems.
   ###
   controller_wallaby::configure_neutron::do_config { 'ovs_bridge_mappings': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'bridge_mappings', value => $controller_wallaby::params::ml2_bridge_mappings, }
   controller_wallaby::configure_neutron::do_config { 'ovs_enable_tunneling': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'enable_tunneling', value => $controller_wallaby::params::ovs_enable_tunneling, }
   # The following parameter was introduced after the powercut of Nov 2018. Without this parameter we had problems with
   # external networks
   ### FF DEPRECATED in PIKE of_interface Open vSwitch agent configuration option --> the current default driver (native) will be the only supported of_interface driver
   ## MS Ma senza abbiamo problemi di rete (forse perche` abbiamo piu` reti esterne ?)
   ## MS con la versione 13.0.3 non dovrebbe piu` servire. V. PDCL-1344
   ## controller_wallaby::configure_neutron::do_config { 'ovs_of_interface': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'ovs', param => 'of_interface', value => $controller_wallaby::params::ovs_of_interface, }
   ###
   controller_wallaby::configure_neutron::do_config { 'ovs_firewall_driver': conf_file => '/etc/neutron/plugins/ml2/openvswitch_agent.ini', section => 'securitygroup', param => 'firewall_driver', value => $controller_wallaby::params::ml2_firewall_driver, } 

# l3_agent.ini

   controller_wallaby::configure_neutron::do_config { 'l3_interface_driver': conf_file => '/etc/neutron/l3_agent.ini', section => 'DEFAULT', param => 'interface_driver', value => $controller_wallaby::params::interface_driver, }

   
   ### FF DEPRECATED in PIKE gateway_external_network_id --> external_network_bridge
   #controller_wallaby::configure_neutron::do_config { 'l3_gateway_external_network_id': conf_file => '/etc/neutron/l3_agent.ini', section => 'DEFAULT', param => 'gateway_external_network_id', value => $controller_wallaby::params::l3_gateway_external_network_id, }
   ## MS external_network_bridge reported as deprecated in the log file. Ma la documentazione dice di settarlo ...
   ##controller_wallaby::configure_neutron::do_config { 'l3_external_network_id': conf_file => '/etc/neutron/l3_agent.ini', section => 'DEFAULT', param => 'external_network_bridge', value => $controller_wallaby::params::l3_external_network_id, }
   ## GS in wallaby external_network_bridge e' deprecato e va rimosso
   #controller_wallaby::configure_neutron::do_config { 'l3_external_network_bridge': conf_file => '/etc/neutron/l3_agent.ini', section => 'DEFAULT', param => 'external_network_bridge', value => $controller_wallaby::params::l3_external_network_bridge, }
   ###


# dhcp_agent.ini

  controller_wallaby::configure_neutron::do_config { 'dhcp_interface_driver': conf_file => '/etc/neutron/dhcp_agent.ini', section => 'DEFAULT', param => 'interface_driver', value => $controller_wallaby::params::interface_driver, }
  controller_wallaby::configure_neutron::do_config { 'dhcp_driver': conf_file => '/etc/neutron/dhcp_agent.ini', section => 'DEFAULT', param => 'dhcp_driver', value => $controller_wallaby::params::dhcp_driver, }

  if $::controller_wallaby::cloud_role == "is_test" {
      file { "$controller_wallaby::params::dnsmasq_config_file":
        ensure   => file,
        owner    => "root",
        group    => "neutron",
        mode     => "0644",
        content  => template("controller_wallaby/dnsmasq-neutron.conf.erb"),
    }
    controller_wallaby::configure_neutron::do_config { 'dnsmasq_config_file': 
      conf_file => '/etc/neutron/dhcp_agent.ini', 
      section => 'DEFAULT', 
      param => 'dnsmasq_config_file', 
      value => $controller_wallaby::params::dnsmasq_config_file,
    }
  }

# metadata_agent.ini
   controller_wallaby::configure_neutron::do_config { 'metadata_auth_ca_cert': conf_file => '/etc/neutron/metadata_agent.ini', section => 'DEFAULT', param => 'auth_ca_cert', value => $controller_wallaby::params::cafile, }
   ### FF DEPRECATED in PIKE nova_metadata_ip --> nova_metadata_host
   #controller_wallaby::configure_neutron::do_config { 'metadata_ip': conf_file => '/etc/neutron/metadata_agent.ini', section => 'DEFAULT', param => 'nova_metadata_ip', value => $controller_wallaby::params::vip_mgmt, }
   controller_wallaby::configure_neutron::do_config { 'metadata_ip': conf_file => '/etc/neutron/metadata_agent.ini', section => 'DEFAULT', param => 'nova_metadata_host', value => $controller_wallaby::params::vip_mgmt, }
   ###
   controller_wallaby::configure_neutron::do_config { 'metadata_metadata_proxy_shared_secret': conf_file => '/etc/neutron/metadata_agent.ini', section => 'DEFAULT', param => 'metadata_proxy_shared_secret', value => $controller_wallaby::params::metadata_proxy_shared_secret, }
  
################

  file {'/etc/neutron/plugin.ini':
              ensure      => link,
              target      => '/etc/neutron/plugins/ml2/ml2_conf.ini',
  }



  # Disable useless OVS loggin in secure file
  file_line { '/etc/sudoers.d/neutron  syslog':
           path   => '/etc/sudoers.d/neutron',
           line   => 'Defaults:neutron !requiretty, !syslog',
           match  => 'Defaults:neutron',
  }

}
