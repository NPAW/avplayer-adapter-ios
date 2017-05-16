apt-get update
apt-get install -y git
mkdir -p ~/.ssh
(umask 077; echo $QA_SSH_KEY | base64 --decode > ~/.ssh/id_rsa)          
git push --prune git@github.com:NPAW/avplayer-adapter-ios.git +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*
