Pod::Spec.new do |s|

  s.name         = "YouboraAVPlayerAdapter"
  s.version      = "6.2.2"

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
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"

  # Source Location
  s.source       = { :git => 'https://bitbucket.org/npaw/avplayer-adapter-ios.git', :tag => s.version}

  # Source files
  s.source_files  = 'YouboraAVPlayerAdapter/**/*.{h,m}'
  s.public_header_files = "YouboraAVPlayerAdapter/**/*.h"

  # Project settings
  s.requires_arc = true
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) YOUBORAADAPTER_VERSION=' + s.version.to_s }

  # Dependency
  s.dependency "YouboraLib", "~>6.2.1"

end
