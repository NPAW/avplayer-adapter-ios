# Deploy to QA

# RSA Keys
puts `mkdir -p ~/.ssh`
puts `echo $QA_KNOWN_HOSTS >> ~/.ssh/known_hosts`
puts `(umask 077; echo $QA_SSH_KEY | base64 --decode > ~/.ssh/id_rsa)`

# Is this a tag or just a normal commit?
branch_name = ENV["TRAVIS_TAG"]

puts `echo "TRAVIS_TAG=${TRAVIS_TAG}"`

if branch_name == nil || branch_name == ""
    deploy_location = "last-build"
else
    deploy_location = "version"
end

puts "Deploying to " + deploy_location

cmd = "scp -r deploy/" + deploy_location + "/* nicedeployer@qa-smartplugin.youbora.com:/home/nicedeployer/qa/catalog/v6/ios/"
puts `#{cmd}`

puts "Done."
