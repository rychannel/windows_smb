# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
 - Configure windows_smb::manage_smb_server_config and windows_smb::manage_client_config to classes from types

## [1.0.1] - 2024-4-02

### Changed
 - Modified Author in CHANGELOG
 - Modified Puppet minimum version requirement as I can't test on lower Puppet versions
 - Updated module to be compatible with PDK 3.0.1

Note: No functionality has been changed or fixed since the 1.0.0 version. No need to upgrade if on v1.0.0.

## [1.0.0] - 2024-4-02
### Addded
 - Data types to Class Parameters
 - Docuemntation for Class Parameters
### Changed
 - Start using Semantic Versioning
 - Updated CHANGELOG format
 - Forked project from [karmabeast/windows_smb](https://forge.puppet.com/modules/karmafeast/windows_smb)
 - Moved current init class to examples/example.pp becuase it doesn't seem to be code that should be used in production.
### Removed
 - Remove references to deprecated validate functions

## [0.4.4] - 2023-9-13

### Changed
 - Converted Module to use PDK 1.13

## [0.4.3] - 2019-09-13

### Fixed
 - incorporate PR from skyrawrcode - vars were not properly initialized in share mgmt class, would cause issue when not populated via params.

## [0.4.2] - 2017-05-03

### Fixed
 - needing this one again... fixed some bad client settings stuff for oplocks which doesnt seem to exist in 2016 at the very least... 

## [0.4.1] - 2016-04-26
### Changed
 - NOTE NEW DEPENDENCY ON `puppetlabs_registry` as of 0.4.0 - see metadata.json

### FIXED
 -  incorrect code block placement for registry defaults in `windows_smb::manage_client_config` - would cause ensure => default resource create to fail, fixed.
 -  doc typos fix

## [0.4.0] - 2016-04-26
### Changed
- NOTE NEW DEPENDENCY ON `puppetlabs_registry` - see metadata.json
- complete rework of resources to manage `windows_smb::manage_client_config` and `windows_smb::manage_server_config` - now like 10x faster to apply due to direct reg mod and its providers direct interface with win APIs
- significant optimization of `windows_smb::manage_client_config` and `windows_smb::manage_server_config`

## [0.3.0] - 2016-04-13

### Added
 - added documentation for `windows_smb::manage_smb_client_config`.
 - __improvements! many things for `managing smb client settings` on windows added - have fun!__
 - many things for `managing smb client settings` on windows added

## [0.2.0] - 2016-04-13

### Added
 - added documentation for `windows_smb::manage_smb_server_config`.
 - bug fixes
 - __improvements!__
 - added support for MaxSessionPerConnection control in `windows_smb::manage_smb_server_config`

### Fixed
 - fixed validator of Uint32 for various params in `windows_smb::manage_smb_share` - was allowing out of range value.

### Changed

 - found defaults for `smb_server_max_channel_per_session` - removed defaulting to `undef` for this param in `windows_smb::manage_smb_server_config`


## [0.1.3] - 2016-04-13

### Added
 - added smb server settings class and example in init, documentation to come.  `windows_smb::manage_smb_server_config` safe to use.

## [0.1.0] - 2016-04

## Initial release - NOTE SUPPORT FOR SMB CLIENT AND SERVER SETTINGS NOT YET IMPLEMENTED - `windows_smb::manage_smb_share` ok to use

## Added
 - added support for managing smb shares on windows systems
