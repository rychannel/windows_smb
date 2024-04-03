# @summary Manage SMB Server Configuration on Windows
#
#
# TODO: Add documentation for type parameters
# @param ensure
# @param smb_server_asynchronous_credits
# @param smb_server_smb2_credits_min 
# @param smb_server_smb2_credits_max
# @param smb_server_max_threads_per_queue
# @param smb_server_treat_host_as_stable_storage
# @param smb_server_max_channel_per_session  
# @param smb_server_max_session_per_connection  
# @param smb_server_additional_critical_worker_threads
# @param smb_server_additional_delayed_worker_threads
# @param smb_server_ntfs_8dot3_name_creation 
# @param smb_server_ntfs_disable_last_access_update 
define windows_smb::manage_smb_server_config (
  Enum['present','default']                                      $ensure                                        = 'present',
  Integer                                                        $smb_server_asynchronous_credits               = 512,
  Integer                                                        $smb_server_smb2_credits_min                   = 512,
  Integer                                                        $smb_server_smb2_credits_max                   = 8192,
  Integer                                                        $smb_server_max_threads_per_queue              = 20,
  Boolean                                                        $smb_server_treat_host_as_stable_storage       = false,
  Integer                                                        $smb_server_max_channel_per_session            = 32,
  Integer                                                        $smb_server_max_session_per_connection         = 16384,
  Integer                                                        $smb_server_additional_critical_worker_threads = 0,
  Integer                                                        $smb_server_additional_delayed_worker_threads  = 0,
  Optional[Enum['0','1','2','enabled','disabled','per_volume']]  $smb_server_ntfs_8dot3_name_creation           = undef,
  Optional[Boolean]                                              $smb_server_ntfs_disable_last_access_update    = undef
) {
  if (!facts['os']['family'] == 'windows') {
    fail('cannot run windows_smb::manage_smb_server_config against non-windows OS platform')
  }

  if ($smb_server_ntfs_8dot3_name_creation == undef) {
    $process_ntfs_8dot3 = false
  } else {
    $process_ntfs_8dot3 = true

    case $smb_server_ntfs_8dot3_name_creation {
      '0', 'enabled': {
        $nfts_8dot3_int = 0
      }
      '1', 'disabled': {
        $nfts_8dot3_int = 1
      }
      '2', 'per_volume': {
        $nfts_8dot3_int = 2
      }
      default: {
        fail('reached default case for 8dot3 name creation - should have been caught by validate_re - logic failure')
      }
    }
  }

  if ($smb_server_ntfs_disable_last_access_update == undef) {
    $process_ntfs_disable_last_access_update = false
  } else {
    $process_ntfs_disable_last_access_update = true

    if ($smb_server_ntfs_disable_last_access_update) {
      $ntfs_disable_last_access_update_int = 1
    } else {
      $ntfs_disable_last_access_update_int = 0
    }
  }

  $smb_server_settings_create_resource_defaults = {
    'ensure' => present,
    'type'   => 'dword',
  }

  if ($ensure == 'present') {
    if ($smb_server_treat_host_as_stable_storage) {
      $smb_server_hoststablestorage_reg_dword = 1
    } else {
      $smb_server_hoststablestorage_reg_dword = 0
    }

    $reg_values = {
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\AsynchronousCredits'              => {
        data => $smb_server_asynchronous_credits,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\smb2creditsmin'                   => {
        data => $smb_server_smb2_credits_min,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\smb2creditsmax'                   => {
        data => $smb_server_smb2_credits_max,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\MaxThreadsPerQueue'               => {
        data => $smb_server_max_threads_per_queue,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\treathostasstablestorage'         => {
        data => $smb_server_hoststablestorage_reg_dword,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\MaxChannelPerSession'             => {
        data => $smb_server_max_channel_per_session,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\MaxSessionPerConnection'          => {
        data => $smb_server_max_session_per_connection,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive\AdditionalCriticalWorkerThreads' => {
        data => $smb_server_additional_critical_worker_threads,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive\AdditionalDelayedWorkerThreads'  => {
        data => $smb_server_additional_delayed_worker_threads,
      }
      ,
    }

    create_resources(registry_value, $reg_values, $smb_server_settings_create_resource_defaults)

    if ($process_ntfs_8dot3) {
      registry_value { 'HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisable8dot3NameCreation':
        ensure => present,
        type   => dword,
        data   => $nfts_8dot3_int,
      }
    }

    if ($process_ntfs_disable_last_access_update) {
      registry_value { 'HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisableLastAccessUpdate':
        ensure => present,
        type   => dword,
        data   => $ntfs_disable_last_access_update_int,
      }
    }
  } else {
    $reg_values = {
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\AsynchronousCredits'              => {
        data => 512,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\smb2creditsmin'                   => {
        data => 512,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\smb2creditsmax'                   => {
        data => 8192,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\MaxThreadsPerQueue'               => {
        data => 20,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\treathostasstablestorage'         => {
        data => 0,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\MaxChannelPerSession'             => {
        data => 32,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\MaxSessionPerConnection'          => {
        data => 16384,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive\AdditionalCriticalWorkerThreads' => {
        data => 0,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive\AdditionalDelayedWorkerThreads'  => {
        data => 0,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisable8dot3NameCreation'                   => {
        data => 2,
      }
      ,
      'HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisableLastAccessUpdate'                    => {
        data => 1,
      }
      ,
    }

    create_resources(registry_value, $reg_values, $smb_server_settings_create_resource_defaults)
  }
}
