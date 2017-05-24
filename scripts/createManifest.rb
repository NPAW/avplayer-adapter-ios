require 'xcodeproj'
require 'json'

# get project name
project_name = ARGV[0]

manifest_name = ARGV[1]

if manifest_name == nil
    manifest_name = project_name
end

project_path = './' + project_name + '.xcodeproj'
project = Xcodeproj::Project.open(project_path)

build_setting_version_key = project_name.upcase + "_VERSION_SETTING"

# project type
project_type = "adapter"

if project_name.downcase.include? "lib"
    project_type = "lib"
end

puts "--- Creating manifest for " + project_name + " (" + project_type + ") ---"

# get project version
version = project.build_settings("Release")[build_setting_version_key]

if version == nil
    puts "Could not get version with key: " + build_setting_version_key
    exit(-1)
end

puts "Version: " + version

# get author
#author_git = `git config user.name`

author_info = `git show --summary | grep Author` 
match = /Author: (?<name>.+?) </.match(author_info)
author_git = match["name"].strip

# get git repo
repo_git = `git config remote.origin.url`

puts "Author from git: " + author_git

if repo_git.include? "@"
    # Strip username
    index_start = repo_git.index("//") + 1
    index_end = repo_git.index("@") + 1
    repo_git = repo_git[0..index_start] + repo_git[index_end..repo_git.length]
end

repo_git.strip!

puts "Repo: " + repo_git

# current date
date_today = Time.now.strftime("%Y-%m-%d")
puts "Date: " + date_today

# create json
json = {
    :name => manifest_name,
    :type => project_type,
    :tech => "ios",
    :author => author_git,
    :version => version,
    :repo => repo_git,
    :built => date_today
}

# if it is an adapter, extract features and getters
if project_type == "adapter"
    allgetters = ['getPlayhead', 'getPlayrate', 'getFramesPerSecond', 'getDroppedFrames',
                  'getDuration', 'getBitrate', 'getThroughput', 'getRendition', 'getTitle',
                  'getTitle2', 'getIsLive', 'getResource', 'getPosition']

    available_getters = []

    native_buffer = false
    native_seek = false

    project_files = project.files

    project_files.each do |file|
        if file.path.end_with? ".m"

            file = File.open(project_name + "/" + file.path, "rb")
            adapter_code = file.read

            if adapter_code.include? "fireBufferBegin"
                native_buffer = true
            end

            if adapter_code.include? "fireSeekBegin"
                native_seek = true
            end

            # Iterate over getters
            allgetters.each do |getter|
                if adapter_code.include? getter
                    available_getters << getter
                end
            end

            file.close()

        end
    end

    if native_buffer
        buffer_type = "native"
    else
        buffer_type = "monitor"
    end

    if native_seek
        seek_type = "native"
    else
        seek_type = "monitor"
    end

    puts "Buffer type: " + buffer_type
    puts "Seek type: " + seek_type
    puts "Detected getters: " + available_getters.to_s

    json[:features] = {:buffer => buffer_type, :seek => seek_type, :getters => available_getters}

end

# save to file
filename = "manifest.json"

if File.exist? filename
    File.delete(filename)
end

f = File.new(filename, "w")
f.write(json.to_json)
f.close()

puts "--- Done ---"
