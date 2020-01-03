//
//  UIView.swift
//  Samples
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import UIKit

extension UIView {
    var className: String {
        return String(describing: type(of: self))
    }
    
    var myBundle: Bundle {
        return Bundle(for: self.classForCoder)
    }
    
    var myNib: UINib {
        return UINib(nibName: className, bundle: myBundle)
    }
    
    func initFromXIB() -> Self {
        return myNib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}
