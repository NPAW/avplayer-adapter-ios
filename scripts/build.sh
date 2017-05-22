#!/bin/bash

# Archive
xcodebuild archive -workspace YouboraAVPlayerAdapter.xcworkspace -scheme AVPlayerAdapterExample -configuration Release -derivedDataPath ./build -archivePath ./build/Products/AVPlayerAdapterExample.xcarchive

# Export IPA
xcodebuild -exportArchive -archivePath ./build/Products/AVPlayerAdapterExample.xcarchive -exportOptionsPlist ./scripts/exportOptions-adHoc.plist -exportPath ./build/Products/IPA
