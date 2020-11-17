Pod::Spec.new do |s|

  s.name         = "YouboraAVPlayerAdapter"
  s.version = '6.5.19'

  # Metadata
  s.summary      = "Adapter to use YouboraLib on AVPlayer"

  s.description  = "<<-DESC
                      YouboraAVPlayerAdapter is an adapter used 
                      for AVPlayer.
                     DESC"

  s.homepage     = "http://developer.nicepeopleatwork.com/"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.author             = { "Nice People at Work" => "support@nicepeopleatwork.com" }

  # Platforms
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"

  # Platforms
  s.swift_version = "4.0", "4.1", "4.2", "4.3", "5.0", "5.1"

  # Source Location
  s.source       = { :git => 'https://bitbucket.org/npaw/avplayer-adapter-ios.git', :tag => s.version}

  # Source files
  s.source_files = 'YouboraAVPlayerAdapter/Generic/**/*.{h,m}'
  s.ios.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ iOS/YouboraAVPlayerAdapter.h'
  s.tvos.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ tvOS/YouboraAVPlayerAdapter.h'
  s.osx.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ OSX/YouboraAVPlayerAdapter.h'

  s.public_header_files = "YouboraAVPlayerAdapter/Generic/**/*.h, YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ iOS/YouboraAVPlayerAdapter.h"

  # Project settings
  s.requires_arc = true
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) YOUBORAADAPTER_VERSION=' + s.version.to_s }

  s.default_subspec = 'Default'

  s.subspec 'Default' do |default|
  # just the plain adapter
  end

  # Dependency
  s.dependency 'YouboraLib', '~> 6.5.19'

  s.subspec 'Streamroot' do |streamroot|

    streamroot.ios.deployment_target = '10.2'
    streamroot.tvos.deployment_target = '10.2'

    streamroot.dependency 'AVPlayerDNAPlugin', '~> 1.1'

    streamroot.public_header_files = "YouboraAVPlayerAdapter/Generic/**/*.h, YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ iOS/YouboraAVPlayerAdapter.h"

    # Source files
    streamroot.source_files = 'YouboraAVPlayerAdapter/Generic/**/*.{h,m}'
    streamroot.ios.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ iOS/YouboraAVPlayerAdapter.h'
    streamroot.tvos.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ tvOS/YouboraAVPlayerAdapter.h'

  end

  s.subspec 'Polynet' do |polynet|
    polynet.ios.deployment_target = '10.2'
    polynet.ios.dependency 'PolyNetSDK', '4.33.113'

    polynet.tvos.deployment_target = '9.0'
    polynet.tvos.dependency 'PolyNetSDKtvOS', '4.32.113'

    polynet.public_header_files = "YouboraAVPlayerAdapter/Generic/**/*.h, YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ iOS/YouboraAVPlayerAdapter.h"

    # Source files
    polynet.source_files = 'YouboraAVPlayerAdapter/Generic/**/*.{h,m}'
    polynet.ios.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ iOS/YouboraAVPlayerAdapter.h'
    polynet.tvos.source_files = 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter\ tvOS/YouboraAVPlayerAdapter.h'
  end
    
end
