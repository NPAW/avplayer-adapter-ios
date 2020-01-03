//
//  VideoResourceTableViewCell.swift
//  Samples
//
//  Created by nice on 21/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import UIKit

class VideoResourceTableViewCell: UITableViewCellFromNib {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkTypeLabel: UILabel!
    
    var viewModel: VideoResourceViewModel? {
        didSet {
            self.populateView()
        }
    }
    
    func populateView() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.linkLabel.text = viewModel.getUrl()
        self.linkTypeLabel.text = viewModel.getType()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
