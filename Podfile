# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'YouboraAVPlayerAdapter.xcworkspace'

def common_pods
    pod 'YouboraLib', '~> 6.5.0'
end

target 'YouboraAVPlayerAdapter' do
  project 'YouboraAVPlayerAdapter.xcodeproj'
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  platform :ios, '10.2'

  # Pods for YouboraAVPlayerAdapter
    common_pods

    pod 'AVPlayerDNAPlugin', '~> 1.1.9'
end 

target 'YouboraAVPlayerAdapter tvOS' do
    project 'YouboraAVPlayerAdapter.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!

    platform :tvos, '9.0' 

    # Pods for YouboraAVPlayerAdapter
    common_pods
end

target 'YouboraAVPlayerAdapter OSX' do
    project 'YouboraAVPlayerAdapter.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!

    platform :osx, '10.10' 

    # Pods for YouboraAVPlayerAdapter
    common_pods
end

def sample_common_pods
    common_pods
    pod 'YouboraConfigUtils'
end

target 'AvPlayerAdapterExample' do
    project 'Samples/Samples.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!
  
    platform :ios, '10.2'
  
    # Pods for AVPlayerAdapterExample
    sample_common_pods
    pod 'AVPlayerDNAPlugin', '~> 1.1.9'
end

target 'AvPlayerAdapterExample-tvOS' do
    project 'Samples/Samples.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!
  
    platform :tvos, '9.0'
  
    # Pods for AVPlayerAdapterExample
    sample_common_pods
end

target 'AvPlayerAdapterExample-macOS' do 
    project 'Samples/Samples.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!
  
    platform :macos, '10.11'
  
    # Pods for AVPlayerAdapterExample
    sample_common_pods
end

target 'AvPlayerP2PAdapterExample' do
  project 'Samples/Samples.xcodeproj'
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  
  platform :ios, '10.2'
  
  # Pods for YouboraAVPlayerAdapter
  sample_common_pods
  pod 'AVPlayerDNAPlugin', '~> 1.1.9'
end

target 'CastVideos-objc' do
    project 'ExampleChromecast/CastVideos-ios.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!

    platform :ios, '9.0'
    pod 'google-cast-sdk', '< 5.0', '>=4.4.2'
    common_pods
end

target 'CastVideos-swift' do
    project 'ExampleChromecast/CastVideos-ios.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!

    platform :ios, '9.0'
    pod 'google-cast-sdk', '< 5.0', '>=4.4.2'
    common_pods
end
