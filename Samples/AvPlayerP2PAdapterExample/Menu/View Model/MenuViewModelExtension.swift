//
//  MenuViewModel.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation

class P2PMenuViewModel: MenuViewModel {
    var selectedP2PMethod = AvailableP2P.Streamroot
    
    func didSelectNewP2PMethod(newIndex: Int) {
        guard let newP2P = AvailableP2P(rawValue: newIndex) else {
            return
        }
        self.selectedP2PMethod = newP2P
    }
    
    override func getPlayerViewModel() -> AvPlayerExampleViewModel? {
        var viewModel: AvPlayerExampleViewModel = AvPlayerExampleViewModelSwift(resource: self.selectedResource, ad: self.selectedAd)
        
        if self.selectedLanguage == .Objc  {
            viewModel = AvPlayerExampleViewModelObjc(self.selectedResource, andAd: self.selectedAd)
        }
        
        viewModel.setSelectedP2P(self.selectedP2PMethod)
        
        return viewModel
    }
}
