//
//  UITableViewCell.swift
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation
import UIKit

fileprivate let DEFAULT_CELL_IDENTIFIER = "Default"

extension UITableViewCell {
    static func getDefault(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DEFAULT_CELL_IDENTIFIER) else {
            return UITableViewCell(style: .default, reuseIdentifier: DEFAULT_CELL_IDENTIFIER)
        }
        
        return cell
    }
}

