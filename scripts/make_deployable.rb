#!/usr/bin/env ruby
require 'fileutils'
require 'xcodeproj'
require 'json'

""" 
Before running this script, the following the manifest.json shold be available.
There's a script for creating that manifest.
'ruby scripts/createManifest.rb'

This script does the following:
- Build and archive the adapter project with Carthage
- Set up example project configuration with xcodeproj utility
- Build the folder structure ready to be uploaded to the CDN.

The script should be invoked from the project root directory.
'ruby scripts/make_deployable.rb <project_name>'
"""

# Build
`pod install`

# Hide Example directory so only the adapter is built
`mv Example .Example`
# Build and archive binary
puts `carthage build --no-skip-current --platform ios`
puts `carthage archive YouboraAVPlayerAdapter`
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
adapter_name = "YouboraAVPlayerAdapter"

framework_ref = @frameworks_group.new_file("./"+adapter_name+".framework")
build_file = embed_build_phase.add_file_reference(framework_ref)
frameworks_build_phase.add_file_reference(framework_ref)
build_file.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy', 'RemoveHeadersOnCopy'] }

# Lib from Carthage
lib_framework = "YouboraLib"

framework_ref = @frameworks_group.new_file("Carthage/Build/iOS/"+lib_framework+".framework")
build_file = embed_build_phase.add_file_reference(framework_ref)
frameworks_build_phase.add_file_reference(framework_ref)
build_file.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy', 'RemoveHeadersOnCopy'] }

@project.save

# Make zip with sample project
puts `zip -r -9 Example.zip Example/`

# Create deployment folder structure
manifest_file_path = 'manifest.json'
if File.directory?('deploy')
    `rm -r deploy`
end

# Load manifest to extract data from it
json = JSON.parse(File.read(manifest_file_path))

version = json["version"]

package_type = ""
deployable_name = "lib"

if (json["type"] == "adapter")
    package_type = "adapters"

    deployable_name = ARGV[0]
    if deployable_name == nil
        deployable_name = json["name"]
    end 
end

last_build_path = "deploy/last-build/" + package_type + "/" + deployable_name + "/last-build"
version_path = "deploy/version/" + package_type + "/" + deployable_name + "/" + version

# Create folder structure
cmd = "mkdir -p " + last_build_path
puts `#{cmd}`

# Copy manifest, sample and ipa
puts "Copying manifest..."
cmd = "cp " + manifest_file_path + " " + last_build_path
puts `#{cmd}`
puts "Copying Example..."
cmd = "cp Example.zip " + last_build_path
puts `#{cmd}`
puts "Copying IPA..."
cmd = "cp build/Products/IPA/AVPlayerAdapterExample.ipa " + last_build_path
puts `#{cmd}`
puts "Copying binary..."
cmd = "cp " + adapter_name + ".framework.zip " + last_build_path
puts `#{cmd}`
# Copy to "version" path
cmd = "mkdir -p " + version_path
puts `#{cmd}`
cmd = "cp -r " + last_build_path + "/* " + version_path
puts `#{cmd}`

puts "Done!"
