# YouboraAVPlayerAdapter

A framework that will collect several video events from the AVPlayer and send it to the back end

# Installation

#### CocoaPods

Insert into your Podfile

```bash
pod 'YouboraAVPlayerAdapter'
```

and then run

```bash
pod install
```

#### Carthage

Insert into your Cartfile

```bash
github "NPAW/avplayer-adapter-ios"
```

and then run

```bash
carthage update
```

when the update finishes go to **{YOUR_SCHEME} > Build Settings > Framework Search Paths** and add **\$(PROJECT_DIR)/Carthage/Build/{iOS, Mac, tvOS or the platform of your scheme}**

## How to use

## Start plugin and options

#### Swift

```swift

//Import
import YouboraLib

...

//Config Options and init plugin (do it just once for each play session)

var options: YBOptions {
        let options = YBOptions()
        options.contentResource = "http://example.com"
        options.accountCode = "accountCode"
        options.adResource = "http://example.com"
        options.contentIsLive = NSNumber(value: false)
        return options;
    }
    
lazy var plugin = YBPlugin(options: self.options)
```

#### Obj-c

```objectivec

//Import
#import <YouboraLib/YouboraLib.h>

...

// Declare the properties
@property YBPlugin *plugin;

...

//Config Options and init plugin (do it just once for each play session)

YBOptions *options = [YBOptions new];
options.offline = false;
options.contentResource = resource.resourceLink;
options.accountCode = @"powerdev";
options.adResource = self.ad?.adLink;
options.contentIsLive = [[NSNumber alloc] initWithBool: resource.isLive];
        
self.plugin = [[YBPlugin alloc] initWithOptions:self.options];
```

For more information about the options you can check [here](http://developer.nicepeopleatwork.com/apidocs/ios6/Classes/YBOptions.html)


### YBAVPlayerAdapter & YBAVPlayerAdsAdapter

#### Swift

```swift
import YouboraAVPlayerAdapter

...

//Once you have your player and plugin initialized you can set the adapter
self.plugin.fireInit()
self.plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))

...

//If you want to setup the ads adapter
self.plugin.adsAdapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdsAdapter(player: player))

...

//When the ad finishes 
self.plugin.removeAdsAdapter()

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
self.plugin.fireStop()
self.plugin.removeAdapter()
self.plugin.removeAdsAdapter()
```

#### Obj-c

```objectivec
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

...

//Once you have your player and plugin initialized you can set the adapter
[self.plugin fireInit];
[self.plugin setAdapter:[[YBAVPlayerAdapter alloc] initWithPlayer:player]];

...

//If you want to setup the ads adapter
[self.plugin setAdsAdapter:[[YBAVPlayerAdsAdapter alloc] initWithPlayer:player]];

...

//When the ad finishes 
[self.plugin removeAdsAdapter];
...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
[self.plugin fireStop];
[self.plugin removeAdapter];
[self.plugin removeAdsAdapter];
```

### YBAVPlayerP2PAdapter

#### Swift

```swift
import YouboraAVPlayerAdapter

...

//Once you have your player, plugin and dnaClient initialized you can set the adapter
self.plugin.fireInit()
self.plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerP2PAdapter(dnaClient: dnaClient, andPlayer: player))

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
self.plugin.fireStop()
self.plugin.removeAdapter()
```

#### Obj-c

```objectivec
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

...

//Once you have your player, dnaClient and plugin initialized you can set the adapter
[self.plugin fireInit];
[self.plugin setAdapter:[[YBAVPlayerP2PAdapter alloc] initWithDnaClient:dnaClient andPlayer:player]];

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
[self.plugin fireStop];
[self.plugin removeAdapter];
```

## Run samples project

###### Via cocoapods

Navigate to the root folder and then execute: 


```bash
pod install
```

1. Now you have to go to your **target > General > Frameworks, Libraries and Embedded Content** and change the frameworks that you are using in cocoapods from **Embed & Sign** to **Do Not Embed**
2. To run the target **AvPlayerP2PAdapterExample** in Samples project you have to use xCode with Swift 5.1 compiler (Xcode 11) because StreamrootSDK was compiled in the version


###### Via carthage (Default)
Navigate to the root folder and then execute: 
```bash
carthage update && cd Samples && carthage update
```

---
**NOTES**

Recently we are having some problems trying to install streamroot by carthage. As workaround and case you face this problem as well you can [download](https://support.streamroot.io/hc/en-us/articles/360003880394-SDK-for-Apple-AVPlayer) directly the framework and add it to the folder Samples/Carthage/Build/iOS

Case you have problems with Swift headers not found, when you're trying to install via **carthage** please do the follow instructions: 

 1. Remove Carthage folder from the project
 2. Execute the follow command ```rm -rf ~/Library/Caches/org.carthage.CarthageKit```

---