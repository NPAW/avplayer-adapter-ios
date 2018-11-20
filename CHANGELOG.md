## [6.2.6] - 2018-11-20
### Updated
- Now iOS adapter requires at least iOS 9.0

## [6.2.5] - 2018-10-03
### Updated
- Update swift version to 4.2

## [6.2.4] - 2018-09-21
### Improved
 - Improved Carthage support for iOS and tvOS

## [6.2.3] - 2018-09-04
### Updated
 - YouboraLib on project updated to 6.2.X
### Fixed
 - It was possible to change start flags without actually sending start request

## [6.2.2] - 2018-09-03
### Fixed
- Fix Cocoapods version mismatch

## [6.2.0] - 2018-08-22
### Updated
- Updated dependency to YouboraLib 6.2.0
### Fixed
- tvOS Deployment target downgraded to iOS 9.0
### Removed
- RemoveAdapter is not called anymore when wrapper fireStop is called

## [6.0.15] - 2018-07-30
### Updated
- Updated dependency to YouboraLib 6.1.8

## [6.0.14] - 2018-07-25
### Fixed
- Freeze when trying to get the duration and it was not loaded

## [6.0.13] - 2018-07-16
### Fixed
- Carthage tvOS now compiles
- Rendition not changing
- Adapter retuning nil if called from wrapper

## [6.0.12] - 2018-05-16
### Fixed
- Fix for Carthage build
- Bitrate now comes from the manifest if possible

## [6.0.11] - 2018-03-08
### Added
- YouboraLib 6.1.5

## [6.0.10] - 2018-03-07
### Added
- YouboraLib 6.1.4

## [6.0.9] - 2018-02-20
### Added
- New error codes
- YouboraLib 6.1.3

## [6.0.8] - 2018-02-15
### Fixed
- Start event for live now send properly with live content

## [6.0.7] - 2018-01-31
### Added
- Now is possible to disable paylist support (no stop when playeritem changes, be careful)

## [6.0.6] - 2018-01-05
### Modified
- Swift wrapper improved

## [6.0.5] - 2017-12-22
### Modified
- Update to YouboraLib 6.0.7

## [6.0.4] - 2017-12-22
### Modified
- Update to YouboraLib 6.0.4

## [6.0.3] - 2017-12-20
### Added
- Swift wrapper
- Support for tvOS on cocoapods
### Modified
- Prevent stop if postrolls
- Improved buffer reporting
- Join time to wrapper
### Deleted
- Unnecesary cocoapods files

## [6.0.2] - 2017-11-07
### Added
- Carthage support
### Deleted
- Unnecesary cocoapods files

## [6.0.1] - 2017-11-06
### Added
- Support for tvOS
### Deleted
- Remove cocoapods to support Carthage properly

## [6.0.1] - 2017-10-05
### Added
- Releae version
 
