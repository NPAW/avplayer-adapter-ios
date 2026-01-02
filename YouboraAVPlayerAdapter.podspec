Pod::Spec.new do |s|

  s.name         = 'YouboraAVPlayerAdapter'
  s.version = '6.7.5'

  # Metadata
  s.summary      = "Adapter to use YouboraLib on AVPlayer"

  s.description  = "<<-DESC
                      YouboraAVPlayerAdapter is an adapter used 
                      for AVPlayer.
                     DESC"

  s.homepage     = "https://documentation.npaw.com/"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.author             = { "NPAW" => "support@nicepeopleatwork.com" }

  # Platforms
  s.ios.deployment_target = "12.0"
  s.tvos.deployment_target = "12.0"
  s.osx.deployment_target = "10.14"

  # Platforms
  s.swift_version = "5.3"

  # Source Location
  s.source       = { :git => 'https://bitbucket.org/npaw/avplayer-adapter-ios.git', :tag => s.version }

  # Source files
  s.source_files = 'Sources/YouboraAVPlayerAdapter'
  # s.ios.source_files = 'Sources/YouboraAVPlayerAdapter/exclude/YouboraAVPlayerAdapter.h'
  # s.tvos.source_files = 'Sources/YouboraAVPlayerAdapter/exclude/YouboraAVPlayerAdapter.h'
  # s.osx.source_files = 'Sources/YouboraAVPlayerAdapter/exclude/YouboraAVPlayerAdapter.h'

  # s.public_header_files = "Sources/YouboraAVPlayerAdapter/**/*.h"

  # Project settings
  s.requires_arc = true
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) YOUBORAADAPTER_VERSION=' + s.version.to_s }

  # Dependency
  s.dependency 'YouboraLib', '~> 6.6'
    
end
