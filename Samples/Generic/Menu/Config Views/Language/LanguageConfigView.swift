//
//  LanguageConfigView.swift
//  Samples
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import UIKit

protocol LanguageConfigViewDelegate: AnyObject {
    func languageIndexDidChange(newIndex: Int);
}

class LanguageConfigView: UIView {
    
    @IBOutlet weak var languagesSegment: UISegmentedControl!
    
    weak var delegate: LanguageConfigViewDelegate?
    
    func selectSegmentIndex(index: Int) {
        self.languagesSegment.selectedSegmentIndex = index
    }

    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        guard let delegate = delegate else { return }
        
        delegate.languageIndexDidChange(newIndex: languagesSegment.selectedSegmentIndex)
    }

}
