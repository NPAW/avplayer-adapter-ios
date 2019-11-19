Pod::Spec.new do |s|

  s.name         = "YouboraAVPlayerAdapter"
  s.version = '6.5.8'

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
  s.source_files  = 'YouboraAVPlayerAdapter/adapter/**/*.{h,m}', 'YouboraAVPlayerAdapter/adsAdapter/**/*.{h,m}', 'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h'
  s.public_header_files = "YouboraAVPlayerAdapter/adapter/**/*.h", "YouboraAVPlayerAdapter/adsAdapter/**/*.h",'YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h'

  # Project settings
  s.requires_arc = true
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) YOUBORAADAPTER_VERSION=' + s.version.to_s }

  s.default_subspec = 'Default'

  s.subspec 'Default' do |default|
  # just the plain adapter
  end

  # Dependency
  s.dependency "YouboraLib"

  s.subspec 'Streamroot' do |streamroot|

    streamroot.ios.deployment_target = '10.2'
    streamroot.tvos.deployment_target = '10.2'

    streamroot.dependency 'AVPlayerDNAPlugin', '~> 1.1.9'
  end

end
