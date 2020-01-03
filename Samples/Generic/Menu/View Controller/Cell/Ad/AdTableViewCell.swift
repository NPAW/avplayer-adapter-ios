//
//  AdTableViewCell.swift
//  Samples
//
//  Created by nice on 22/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import UIKit

class AdTableViewCell: UITableViewCellFromNib {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: AdCellViewModel? {
        didSet {
            self.populateCell()
        }
    }

    private func populateCell() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.titleLabel.text = viewModel.getTitle()
    }
    
}
