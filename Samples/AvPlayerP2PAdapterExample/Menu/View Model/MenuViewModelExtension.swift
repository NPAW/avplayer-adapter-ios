//
//  MenuViewModel.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation

class P2PMenuViewModel: MenuViewModel {
    override func getPlayerViewModel() -> AvPlayerExampleViewModel? {
        if self.selectedLanguage == .Objc  {
            return AvPlayerExampleViewModelObjc(self.selectedResource, andAd: self.selectedAd)
        }
        
        return AvPlayerExampleViewModelSwift(resource: self.selectedResource, ad: self.selectedAd)
    }
}
