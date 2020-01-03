//
//  AdCellViewModel.swift
//  Samples
//
//  Created by nice on 22/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import Foundation

class AdCellViewModel {
    private let adOption: MenuAdOption
    
    init(ad: MenuAdOption) {
        self.adOption = ad
    }
    
    func getTitle() -> String {
        return adOption.title
    }
}
