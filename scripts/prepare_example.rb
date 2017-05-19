#!/usr/bin/env ruby
require 'fileutils'
require 'xcodeproj'

# Build
`pod install`

# Hide Example directory so only the adapter is built
`mv Example .Example`
puts `carthage update --no-skip-current --platform ios`
`mv .Example Example`

# Build sample dependencies
Dir.chdir("Example") do
    puts `carthage update --platform ios`
end

# Copy adapter framework to Example dir
`cp -r Carthage/Build/iOS/YouboraAVPlayerAdapter.framework Example/`

puts `pod deintegrate`
Dir.chdir("Example") do
    puts `pod deintegrate`
end

# Add youboralib to Cartfile
`echo "github \\"NPAW/lib-plugin-ios\\"" >> Example/Cartfile`

# Build Example carthage
Dir.chdir("Example") do
    puts `carthage update --platform ios`
    `rm -r Carthage/Checkouts`
    `rm -r Carthage/Build/tvOS`
end

# Useful vars
@project = Xcodeproj::Project.open('Example/AVPlayerAdapterExample.xcodeproj')
@frameworks_group = @project.groups.find { |group| group.display_name == 'Frameworks' }

target = @project.targets.find { |target| target.to_s == "AVPlayerAdapterExample" }
frameworks_build_phase = target.build_phases.find { |build_phase| build_phase.to_s == 'FrameworksBuildPhase' }
embed_build_phase = target.build_phases.find { |build_phase| build_phase.to_s == 'Embed Frameworks' }

# Remove references
# Lib
file = @project.objects.find{|object| object.display_name == 'YouboraAVPlayerAdapter.framework'}
if file != nil 
    fileref = file.file_ref
    frameworks_build_phase.remove_file_reference(file.file_ref)
    embed_build_phase.remove_file_reference(fileref)
end

# Project
subproject = @project.root_object.project_references[0].values.find { |item| item.to_s == 'YouboraAVPlayerAdapter.xcodeproj' }
subproject.remove_from_project

# Embed frameworks in sample project
# Adapter
framework_name = "YouboraAVPlayerAdapter"

framework_ref = @frameworks_group.new_file("./"+framework_name+".framework")
build_file = embed_build_phase.add_file_reference(framework_ref)
frameworks_build_phase.add_file_reference(framework_ref)
build_file.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy', 'RemoveHeadersOnCopy'] }

# Lib from Carthage
framework_name = "YouboraLib"

framework_ref = @frameworks_group.new_file("Carthage/Build/iOS/"+framework_name+".framework")
build_file = embed_build_phase.add_file_reference(framework_ref)
frameworks_build_phase.add_file_reference(framework_ref)
build_file.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy', 'RemoveHeadersOnCopy'] }

@project.save
