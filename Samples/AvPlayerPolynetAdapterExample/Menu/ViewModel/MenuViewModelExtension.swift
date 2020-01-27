//
//  MenuViewModelExtension.swift
//  AvPlayerPolynetAdapterExample
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

import Foundation

class PolynetMenuViewModel: MenuViewModel {
    override func getPlayerViewModel() -> AvPlayerExampleViewModel? {
        return AvPlayerExampleViewModelSwift(resource: self.selectedResource, ad: self.selectedAd)
    }
}
