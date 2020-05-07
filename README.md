# YouboraAVPlayerAdapter

A framework that will collect several video events from the AVPlayer and send it to the back end

# Installation

#### CocoaPods

Insert into your Podfile

```bash
pod 'YouboraAVPlayerAdapter'
```

or if you are using Streamroot

```bash
pod 'YouboraAVPlayerAdapter/Streamroot'
```

or for System73

```bash
pod 'YouboraAVPlayerAdapter/Polynet'
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

#### Obj-C

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

#### Obj-C

```objectivec
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

...

//Once you have your player and plugin initialized you can set the adapter
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

### YBAVPlayerStreamrootAdapter

To install with pods

```bash
pod 'YouboraAVPlayerAdapter/Streamroot'
```

#### Swift

```swift
import YouboraAVPlayerAdapter

...

//Once you have your player, plugin and dnaClient initialized you can set the adapter
self.plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerStreamrootAdapter(dnaClient: dnaClient, andPlayer: player))

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
self.plugin.fireStop()
self.plugin.removeAdapter()
```

#### Obj-C

```objectivec
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

...

//Once you have your player, dnaClient and plugin initialized you can set the adapter
[self.plugin setAdapter:[[YBAVPlayerStreamrootAdapter alloc] initWithDnaClient:dnaClient andPlayer:player]];

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
[self.plugin fireStop];
[self.plugin removeAdapter];
```

### YBAVPlayerPolynetAdapter

To install with pods

```bash
pod 'YouboraAVPlayerAdapter/Polynet'
```

#### Swift

```swift
import YouboraAVPlayerAdapter

...

//Once you have your player, plugin and polynet initialized you can set the adapter
self.plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerPolynetAdapter(polyNet: polynet, player: player, andDelegate: polynetDelegate))

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
self.plugin.fireStop()
self.plugin.removeAdapter()
```

#### Obj-C

```objectivec
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

...

//Once you have your player, polynet and plugin initialized you can set the adapter
[self.plugin setAdapter:[[YBAVPlayerPolynetAdapter alloc] initWithPolyNet:polynet player:player andDelegate:polynetDelegate]];

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
[self.plugin fireStop];
[self.plugin removeAdapter];
```

By the examples code you can see that the adapter allows to pass the polynet delegate by reference. This is because polynet allows just one delegate. So if you want to use this delegate you need to send it by our adapter

## Run samples project

###### Via cocoapods

Navigate to the root folder and then execute: 


```bash
pod install
```

Case you want to run Streamroot or Polynet examples then you have to go to the **Podfile** and uncomment inside of **p2p_pods** the one that you want to use. You can't use both at the same time because they share a dependency with different versions what will cause a compatibility issue.

1. Now you have to go to your **target > General > Frameworks, Libraries and Embedded Content** and change the frameworks that you are using in cocoapods from **Embed & Sign** to **Do Not Embed**
2. To run the target **AvPlayerP2PAdapterExample** in Samples project you have to use Xcode with Swift 5.1 compiler (Xcode 11) because StreamrootSDK was compiled in the version


###### Via carthage (Default)
Similar to cocoapods if you want to use **Streamroot** or **Polynet** examples you should go to the carthage file inside of **Samples** folder and uncomment the one you wish to use. Once more you **can't use both** at the same time since they share a dependecy with different versions

Case you run **Polynet** example then you have to use **Xcode 11.3** because **PolyNetSDK** was build with swift compiler 5.1.3

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