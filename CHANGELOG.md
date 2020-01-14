## [6.5.13] - 2020-01-14
### Fixed
- Fix issue with the headers for tvOS target
## [6.5.12] - 2020-01-08
### Fixed
- Fix issue with the headers with cocoa pods
## [6.5.11] - 2019-12-29
### Added
- Swift transformer that will give swift compatibility to the adapter 
### Removed
- Swift wrapper

## [6.5.10] - 2019-11-26
### Fixed
- Proper null check on the ad adapter wrapper

## [6.5.9] - 2019-11-19
### Fixed
- Swift wrapper now is set as the adAdapter
- Import not working properly for YouboraLib 6.5.9

## [6.5.8] - 2019-11-06
### Fixed
- Playrate now has a default value of 1 in case of seek or buffer

## [6.5.7] - 2019-10-30
### Added
- Swift wrapper for ads adapter
### Fixed
- Carthage now supports Streamroot (up until Swift 5.0)

## [6.5.6] - 2019-09-19
### Misc
- Dummy update to test new travis CI config file

## [6.5.5] - 2019-09-04
### Improved
- Now no join time is fired unless the rate is different from 0 and the playhead greater than 100ms

## [6.5.4] - 2019-08-08
### Added
- Extra ad adapter to use along with avplayer itself

## [6.5.3] - 2019-08-08
### Fixed
- Optional Streamroot dependency

## [6.5.2] - 2019-08-08
### Added
- Support for Streamroot

## [6.5.1] - 2019-07-24
### Fix
- Certain conditions were triggering a fake fireStop in case of content being live

## [6.5.0] - 2019-06-26
### Updated
- Bump Youboralib to 6.5.0

## [6.4.2] - 2019-06-05
### Added
- Constructor to use custom adapters on the wrapper

## [6.4.1] - 2019-05-29
### Added
- Mac OS support
### Upgraded
- Upgrade to Swift 5
### Improved
- Removed join time log once join time has been sent

## [6.4.0] - 2019-04-02
### Updated
- Bump YouboraLib dependency to 6.4

## [6.3.3] - 2019-02-13
### Added
- AutoJoinTime flag 

## [6.3.2] - 2019-02-06
### Fixed
- Removing observers should not cause a crash

## [6.3.0] - 2019-01-24
### Improved
- Update YouboraLib to 6.3.0 to support playrate

## [6.2.8] - 2018-12-05
### Improved
- Check states before starting to pause or not

## [6.2.7] - 2018-12-05
### Improved
- Added extra checks before firing pause

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
 
