apt-get update
apt-get install -y git
#mkdir -p ~/.ssh
git push --prune git@github.com:NPAW/avplayer-adapter-ios.git +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*
