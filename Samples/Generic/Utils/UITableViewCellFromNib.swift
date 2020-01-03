//
//  UITableViewCellFromNib.swift
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation
import UIKit

class UITableViewCellFromNib: UITableViewCell {
    var customBundle: Bundle {
        return Bundle(for: self.classForCoder)
    }
    
    var customNib: [Any]? {
        return customBundle.loadNibNamed(className, owner: nil, options: nil)
    }
    
    public var customIdentifier:String {
        return self.className
    }
    
    func registerCell(tableView: UITableView) {
        
        let className = self.className
        let customBundle = self.customBundle
        
        tableView.register(UINib(nibName: className, bundle: customBundle), forCellReuseIdentifier: className)
    }
    
    func initFromXib() -> UITableViewCellFromNib? {
        guard let nib = customNib else {
            return nil
        }
        
        return nib[0] as? UITableViewCellFromNib
    }
}
