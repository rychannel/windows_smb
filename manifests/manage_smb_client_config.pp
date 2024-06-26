# @summary Manage SMB Client Config on Windows
#
# TODO: Add docuemtnation for each parameter 
# TODO: Add example usage
#
# @param ensure
# @param smb_client_connection_count_per_interface  
# @param smb_client_connection_count_per_rss_interface  
# @param smb_client_connection_count_per_rdma_interface
# @param smb_client_connection_count_per_server_max
# @param smb_client_dormant_directory_timeout_seconds
# @param smb_client_directory_cache_lifetime_seconds
# @param smb_client_dormant_file_limit
# @param smb_client_directory_cache_entries_max
# @param smb_client_directory_cache_entry_size_max_bytes
# @param smb_client_file_not_found_cache_lifetime_seconds
# @param smb_client_file_not_found_cache_entries_max
# @param smb_client_file_info_cache_lifetime_seconds
# @param smb_client_file_info_cache_entries_max
# @param smb_client_enable_bandwidth_throttling
# @param smb_client_enable_large_mtu
# @param smb_client_enable_byte_range_locking_read_only_files
# @param smb_client_enable_multichannel
# @param smb_client_extended_session_timeout_seconds
# @param smb_client_keep_connection_seconds
# @param smb_client_max_commands
# @param smb_client_oplocks_disabled  
# @param smb_client_session_timeout_seconds
# @param smb_client_use_opportunistic_locking 
# @param smb_client_window_size_threshold
define windows_smb::manage_smb_client_config (
  Enum['present','default']  $ensure                                               = 'present',
  Integer                    $smb_client_connection_count_per_interface            = 1,
  Integer                    $smb_client_connection_count_per_rss_interface        = 4,
  Integer                    $smb_client_connection_count_per_rdma_interface       = 2,
  Integer                    $smb_client_connection_count_per_server_max           = 32,
  Integer                    $smb_client_dormant_directory_timeout_seconds         = 600,
  Integer                    $smb_client_directory_cache_lifetime_seconds          = 10,
  Integer                    $smb_client_dormant_file_limit                        = 1023,
  Integer                    $smb_client_directory_cache_entries_max               = 16,
  Integer                    $smb_client_directory_cache_entry_size_max_bytes      = 65536,
  Integer                    $smb_client_file_not_found_cache_lifetime_seconds     = 5,
  Integer                    $smb_client_file_not_found_cache_entries_max          = 128,
  Integer                    $smb_client_file_info_cache_lifetime_seconds          = 10,
  Integer                    $smb_client_file_info_cache_entries_max               = 64,
  Boolean                    $smb_client_enable_bandwidth_throttling               = true,
  Boolean                    $smb_client_enable_large_mtu                          = true,
  Boolean                    $smb_client_enable_byte_range_locking_read_only_files = true,
  Boolean                    $smb_client_enable_multichannel                       = true,
  Integer                    $smb_client_extended_session_timeout_seconds          = 1000,
  Integer                    $smb_client_keep_connection_seconds                   = 600,
  Integer                    $smb_client_max_commands                              = 50,
  Boolean                    $smb_client_oplocks_disabled                          = false,
  Integer                    $smb_client_session_timeout_seconds                   = 60,
  Boolean                    $smb_client_use_opportunistic_locking                 = true,
  Integer                    $smb_client_window_size_threshold                     = 1
) {
  if (!$facts['os']['family'] == 'windows') {
    fail('cannot run windows_smb::manage_smb_client_config against non-windows OS platform')
  }

  $smb_client_settings_create_resource_defaults = {
    'ensure' => present,
    'type'   => 'dword',
  }

  if ($ensure == 'present') {
    if ($smb_client_enable_bandwidth_throttling) {
      $smb_client_bandwidththrottle_reg_dword = 0
    } else {
      $smb_client_bandwidththrottle_reg_dword = 1
    }

    if ($smb_client_enable_large_mtu) {
      $smb_client_largemtu_reg_dword = 0
    } else {
      $smb_client_largemtu_reg_dword = 1
    }

    if ($smb_client_enable_byte_range_locking_read_only_files) {
      $smb_client_byterangelocking_reg_dword = 0
    } else {
      $smb_client_byterangelocking_reg_dword = 1
    }

    if ($smb_client_enable_multichannel) {
      $smb_client_multichannel_reg_dword = 0
    } else {
      $smb_client_multichannel_reg_dword = 1
    }

    if ($smb_client_oplocks_disabled) {
      $smb_client_oplocks_reg_dword = 1
    } else {
      $smb_client_oplocks_reg_dword = 0
    }

    if ($smb_client_use_opportunistic_locking) {
      $smb_client_use_oplocks_reg_dword = 1
    } else {
      $smb_client_use_oplocks_reg_dword = 0
    }

    $reg_values = {
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ConnectionCountPerNetworkInterface'     => {
        data => $smb_client_connection_count_per_interface,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ConnectionCountPerRssNetworkInterface'  => {
        data => $smb_client_connection_count_per_rss_interface,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ConnectionCountPerRdmaNetworkInterface' => {
        data => $smb_client_connection_count_per_rdma_interface,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\MaximumConnectionCountPerServer'        => {
        data => $smb_client_connection_count_per_server_max,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DormantDirectoryTimeout'                => {
        data => $smb_client_dormant_directory_timeout_seconds,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileInfoCacheLifetime'                  => {
        data => $smb_client_file_info_cache_lifetime_seconds,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheLifetime'                 => {
        data => $smb_client_directory_cache_lifetime_seconds,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheEntrySizeMax'             => {
        data => $smb_client_directory_cache_entry_size_max_bytes,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheEntriesMax'               => {
        data => $smb_client_directory_cache_entries_max,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileNotFoundCacheLifetime'              => {
        data => $smb_client_file_not_found_cache_lifetime_seconds,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableBandwidthThrottling'             => {
        data => $smb_client_bandwidththrottle_reg_dword,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableLargeMtu'                        => {
        data => $smb_client_largemtu_reg_dword,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableByteRangeLockingOnReadOnlyFiles' => {
        data => $smb_client_byterangelocking_reg_dword,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableMultiChannel'                    => {
        data => $smb_client_multichannel_reg_dword,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ExtendedSessTimeout'                    => {
        data => $smb_client_extended_session_timeout_seconds,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileInfoCacheEntriesMax'                => {
        data => $smb_client_file_info_cache_entries_max,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileNotFoundCacheEntriesMax'            => {
        data => $smb_client_file_not_found_cache_entries_max,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\MaxCmds'                                => {
        data => $smb_client_max_commands,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\KeepConn'                               => {
        data => $smb_client_keep_connection_seconds,
      }
      ,
      #'HKLM\SYSTEM\CurrentControlSet\Services\SmbMRx\Parameters\OplocksDisabled'                                   => {
      #  data => $smb_client_oplocks_reg_dword,
      #}
      #,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\SESSTIMEOUT'                            => {
        data => $smb_client_session_timeout_seconds,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\UseOpportunisticLocking'                => {
        data => $smb_client_use_oplocks_reg_dword,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\WindowSizeThreshold'                    => {
        data => $smb_client_window_size_threshold,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DormantFileLimit'                       => {
        data => $smb_client_dormant_file_limit,
      }
      ,
    }

    create_resources(registry_value, $reg_values, $smb_client_settings_create_resource_defaults)
  } else {
    $reg_values = {
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ConnectionCountPerNetworkInterface'     => {
        data => 1,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ConnectionCountPerRssNetworkInterface'  => {
        data => 4,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ConnectionCountPerRdmaNetworkInterface' => {
        data => 2,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\MaximumConnectionCountPerServer'        => {
        data => 32,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DormantDirectoryTimeout'                => {
        data => 600,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileInfoCacheLifetime'                  => {
        data => 10,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheLifetime'                 => {
        data => 10,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheEntrySizeMax'             => {
        data => 65536,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheEntriesMax'               => {
        data => 16,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileNotFoundCacheLifetime'              => {
        data => 5,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableBandwidthThrottling'             => {
        data => 0,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableLargeMtu'                        => {
        data => 0,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableByteRangeLockingOnReadOnlyFiles' => {
        data => 0,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableMultiChannel'                    => {
        data => 0,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\ExtendedSessTimeout'                    => {
        data => 1000,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileInfoCacheEntriesMax'                => {
        data => 64,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileNotFoundCacheEntriesMax'            => {
        data => 128,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\MaxCmds'                                => {
        data => 50,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\KeepConn'                               => {
        data => 600,
      }
      ,
      #'HKLM\SYSTEM\CurrentControlSet\Services\SmbMRx\Parameters\OplocksDisabled'                                   => {
      #  data => 0,
      #}
      #,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\SESSTIMEOUT'                            => {
        data => 60,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\UseOpportunisticLocking'                => {
        data => 1,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\WindowSizeThreshold'                    => {
        data => 1,
      }
      ,
      'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\DormantFileLimit'                       => {
        data => 1023,
      }
      ,
    }

    create_resources(registry_value, $reg_values, $smb_client_settings_create_resource_defaults)
  }
}
