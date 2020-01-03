//
//  MenuViewControllerExtension.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation

extension MenuViewController: P2PConfigViewDelegate {
    
    func startP2PViewModel() {
        self.viewModel = P2PMenuViewModel()
    }
    
    func addP2PConfigView() {
        let configView = P2PConfigView().initFromXIB()
        configView.delegate = self
        
        self.configViews.append(configView)
        
        guard let viewModel = self.viewModel as? P2PMenuViewModel else {
            return
        }
        
        configView.selectSegmentIndex(index: viewModel.selectedP2PMethod.rawValue)
    }
    
    func p2pIndexDidChange(newIndex: Int) {
        guard let viewModel = self.viewModel as? P2PMenuViewModel else {
            return
        }
        
        viewModel.didSelectNewP2PMethod(newIndex: newIndex)
    }
}
