# Set up HA for OpenStack controller services
class openstack::controller_ha (
   $controllers,
   $primary_controller,
   $controller_public_addresses, $public_interface, $private_interface = 'eth2', $controller_internal_addresses,
   $internal_virtual_ip, $public_virtual_ip, $internal_address,
   $floating_range, $fixed_range, $multi_host, $network_manager, $verbose, $debug = false, $network_config = {}, $num_networks = 1, $network_size = 255,
   $auto_assign_floating_ip = false, $mysql_root_password, $admin_email, $admin_user = 'admin', $admin_password, $keystone_admin_tenant='admin',
   $keystone_db_password, $keystone_admin_token, $glance_db_password, $glance_user_password, $glance_image_cache_max_size,
   $nova_db_password, $nova_user_password,
   $queue_provider, $amqp_hosts, $amqp_user, $amqp_password, $rabbit_ha_queues=true,
   $rabbitmq_bind_ip_address, $rabbitmq_bind_port, $rabbitmq_cluster_nodes,
   $memcached_servers, $export_resources, $glance_backend='file', $swift_proxies=undef, $rgw_servers=undef,
   $quantum = false,
   $quantum_config={},
   $cinder = false, $cinder_iscsi_bind_addr = false,
   $nv_physical_volume = undef, $manage_volumes = false,  $custom_mysql_setup_class = 'galera', $galera_nodes, $use_syslog = false, $syslog_log_level = 'WARNING',
   $syslog_log_facility_glance   = 'LOG_LOCAL2',
   $syslog_log_facility_cinder   = 'LOG_LOCAL3',
   $syslog_log_facility_neutron  = 'LOG_LOCAL4',
   $syslog_log_facility_nova     = 'LOG_LOCAL6',
   $syslog_log_facility_keystone = 'LOG_LOCAL7',
   $cinder_rate_limits = undef, $nova_rate_limits = undef,
   $cinder_volume_group     = 'cinder-volumes',
   $cinder_user_password    = 'cinder_user_pass',
   $cinder_db_password      = 'cinder_db_pass',
   $ceilometer                 = false,
   $ceilometer_db_password     = 'ceilometer_pass',
   $ceilometer_user_password   = 'ceilometer_pass',
   $ceilometer_metering_secret = 'ceilometer',
   $savanna                 = false,
   $horizon_use_ssl         = false,
   $quantum_network_node    = false,
   $quantum_netnode_on_cnt  = false,
   $mysql_skip_name_resolve = false,
   $ha_provider             = "pacemaker",
   $create_networks         = true,
   $use_unicast_corosync    = false,
   $ha_mode                 = true,
   $nameservers             = undef,
   $nova_report_interval    = '10',
   $nova_service_down_time  = '60',
 ) {

    $is_primary_controller = $::fuel_settings['role'] ? { 'primary-controller'=>true, default=>false }

    class { '::openstack::ha::haproxy':
      controllers              => $controllers,
      public_virtual_ip        => $public_virtual_ip,
      internal_virtual_ip      => $internal_virtual_ip,
      horizon_use_ssl          => $horizon_use_ssl,
      neutron                  => $quantum,
      queue_provider           => $queue_provider,
      custom_mysql_setup_class => $custom_mysql_setup_class,
      swift_proxies            => $swift_proxies,
      rgw_servers              => $rgw_servers,
      ceilometer               => $ceilometer,
      savanna                  => $savanna,
      is_primary_controller    => $is_primary_controller,
    }

    class { '::openstack::controller':
      private_interface       => $private_interface,
      public_interface        => $public_interface,
      public_address          => $public_virtual_ip,    # It is feature for HA mode.
      internal_address        => $internal_virtual_ip,  # All internal traffic goes
      admin_address           => $internal_virtual_ip,  # through load balancer.
      floating_range          => $floating_range,
      fixed_range             => $fixed_range,
      multi_host              => $multi_host,
      network_config          => $network_config,
      num_networks            => $num_networks,
      network_size            => $network_size,
      network_manager         => $network_manager,
      verbose                 => $verbose,
      debug                   => $debug,
      auto_assign_floating_ip => $auto_assign_floating_ip,
      mysql_root_password     => $mysql_root_password,
      custom_mysql_setup_class=> $custom_mysql_setup_class,
      galera_cluster_name     => 'openstack',
      primary_controller      => $primary_controller,
      galera_node_address     => $internal_address,
      galera_nodes            => $galera_nodes,
      mysql_skip_name_resolve => $mysql_skip_name_resolve,
      admin_email             => $admin_email,
      admin_user              => $admin_user,
      admin_password          => $admin_password,
      keystone_db_password    => $keystone_db_password,
      keystone_admin_token    => $keystone_admin_token,
      keystone_admin_tenant   => $keystone_admin_tenant,
      glance_db_password      => $glance_db_password,
      glance_user_password    => $glance_user_password,
      glance_api_servers      => $glance_api_servers,
      glance_image_cache_max_size => $glance_image_cache_max_size,
      nova_db_password        => $nova_db_password,
      nova_user_password      => $nova_user_password,
      queue_provider          => $queue_provider,
      amqp_hosts              => $amqp_hosts,
      amqp_user               => $amqp_user,
      amqp_password           => $amqp_password,
      rabbit_ha_queues        => $rabbit_ha_queues,
      rabbitmq_bind_ip_address => $rabbitmq_bind_ip_address,
      rabbitmq_bind_port      => $rabbitmq_bind_port,
      rabbitmq_cluster_nodes  => $rabbitmq_cluster_nodes,
      rabbit_cluster          => true,
      cache_server_ip         => $memcached_servers,
      export_resources        => false,
      api_bind_address        => $internal_address,
      db_host                 => $internal_virtual_ip,
      service_endpoint        => $internal_virtual_ip,
      glance_backend          => $glance_backend,
      #require                 => Service['keepalived'],
      quantum                 => $quantum,
      quantum_config          => $quantum_config,
      quantum_network_node    => $quantum_network_node,
      quantum_netnode_on_cnt  => $quantum_netnode_on_cnt,
      segment_range           => $segment_range,
      tenant_network_type     => $tenant_network_type,
      cinder                  => $cinder,
      cinder_iscsi_bind_addr  => $cinder_iscsi_bind_addr,
      cinder_user_password    => $cinder_user_password,
      cinder_db_password      => $cinder_db_password,
      manage_volumes          => $manage_volumes,
      nv_physical_volume      => $nv_physical_volume,
      cinder_volume_group     => $cinder_volume_group,
      ceilometer              => $ceilometer,
      ceilometer_db_password  => $ceilometer_db_password,
      ceilometer_user_password => $ceilometer_user_password,
      ceilometer_metering_secret => $ceilometer_metering_secret,
      # turn on SWIFT_ENABLED option for Horizon dashboard
      swift                        => $glance_backend ? { 'swift'    => true, default => false },
      use_syslog                   => $use_syslog,
      syslog_log_level             => $syslog_log_level,
      syslog_log_facility_glance   => $syslog_log_facility_glance,
      syslog_log_facility_cinder   => $syslog_log_facility_cinder,
      syslog_log_facility_nova     => $syslog_log_facility_nova,
      syslog_log_facility_keystone => $syslog_log_facility_keystone,
      cinder_rate_limits           => $cinder_rate_limits,
      nova_rate_limits             => $nova_rate_limits,
      nova_report_interval         => $nova_report_interval,
      nova_service_down_time       => $nova_service_down_time,
      horizon_use_ssl              => $horizon_use_ssl,
      ha_mode                      => $ha_mode,
      nameservers                  => $nameservers,
    }

    if $quantum and $quantum_network_node {
      class { '::openstack::neutron_router':
        #service_endpoint      => $internal_virtual_ip,
        #auth_host             => $internal_virtual_ip,
        #nova_api_vip          => $internal_virtual_ip,
        #private_interface     => $private_interface,
        #segment_range         => $segment_range,
        #internal_address      => $internal_address,
        #public_interface      => $public_interface,
        #create_networks       => $create_networks,
        verbose               => $verbose,
        debug                 => $debug,
        neutron               => $quantum,
        neutron_config        => $quantum_config,
        neutron_network_node  => $quantum_network_node,
        #neutron_netnode_on_cnt=> $quantum_netnode_on_cnt,
        service_provider      => $ha_provider,
        use_syslog            => $use_syslog,
        syslog_log_level      => $syslog_log_level,
        syslog_log_facility   => $syslog_log_facility_neutron,
        ha_mode               => $ha_mode,
      }
    }

    class { 'openstack::auth_file':
      admin_user              => $admin_user,
      admin_password          => $admin_password,
      admin_tenant            => $keystone_admin_tenant,
      keystone_admin_token    => $keystone_admin_token,
      controller_node         => $internal_virtual_ip,
    }
}
