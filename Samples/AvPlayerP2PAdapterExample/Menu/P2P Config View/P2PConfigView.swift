//
//  P2PConfigView.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import UIKit

protocol P2PConfigViewDelegate: AnyObject {
    func p2pIndexDidChange(newIndex: Int);
}

class P2PConfigView: UIView {
    
    @IBOutlet weak var p2pOptionsSegment: UISegmentedControl!
    
    weak var delegate: P2PConfigViewDelegate?
    
    func selectSegmentIndex(index: Int) {
        self.p2pOptionsSegment.selectedSegmentIndex = index
    }

    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        guard let delegate = delegate else { return }
        
        delegate.p2pIndexDidChange(newIndex: p2pOptionsSegment.selectedSegmentIndex)
    }

}
