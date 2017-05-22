#!/bin/bash

# Development
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in scripts/certs/development-cer.cer.enc -d -a -out scripts/certs/development-cer.cer
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in scripts/certs/development-key.p12.enc -d -a -out scripts/certs/development-key.p12
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in scripts/provisioning-profile/development-provisioning-profile.mobileprovision.enc -d -a -out scripts/provisioning-profile/development-provisioning-profile.mobileprovision

# Distribution
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in scripts/certs/distribution-cer.cer.enc -d -a -out scripts/certs/distribution-cer.cer
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in scripts/certs/distribution-key.p12.enc -d -a -out scripts/certs/distribution-key.p12
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in scripts/provisioning-profile/distribution-provisioning-profile.mobileprovision.enc -d -a -out scripts/provisioning-profile/distribution-provisioning-profile.mobileprovision

# Create custom keychain
security create-keychain -p $CUSTOM_KEYCHAIN_PASSWORD ios-build.keychain
# Make the ios-build.keychain default, so xcodebuild will use it
security default-keychain -s ios-build.keychain
# Unlock the keychain
security unlock-keychain -p $CUSTOM_KEYCHAIN_PASSWORD ios-build.keychain
# Set keychain timeout to 1 hour for long builds
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

# Import certificates and keys
security import ./scripts/certs/AppleWWDRCA.cer -k ios-build.keychain -A
security import ./scripts/certs/development-cer.cer -k ios-build.keychain -A
security import ./scripts/certs/development-key.p12 -k ios-build.keychain -P $SECURITY_PASSWORD -A
security import ./scripts/certs/distribution-cer.cer -k ios-build.keychain -A
security import ./scripts/certs/distribution-key.p12 -k ios-build.keychain -P $SECURITY_PASSWORD -A

# Install provisioning profile
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "./scripts/provisioning-profile/development-provisioning-profile.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
cp "./scripts/provisioning-profile/distribution-provisioning-profile.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/

# Fix for OS X Sierra that hungs in the codesign step
security set-key-partition-list -S apple-tool:,apple: -s -k $CUSTOM_KEYCHAIN_PASSWORD ios-build.keychain > /dev/null
