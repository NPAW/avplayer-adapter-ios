//
//  ConfigContainerViewController.swift
//  SeveralUtils
//
//  Created by nice on 22/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import UIKit
import YouboraConfigUtils

@objcMembers class ConfigContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.addCloseButton()
        // Do any additional setup after loading the view.
    }
    
    func addCloseButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.textAlignment = .center
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.addTarget(self, action: #selector(closeViewController), for: .allTouchEvents)
        
        self.view.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        ])
        
        addViewControllerContainer(button: closeButton)
    }
    
    func addViewControllerContainer(button: UIButton) {
        let viewControllerContainer = UIViewController()
        self.addChild(viewControllerContainer)
        
        self.view.addSubview(viewControllerContainer.view)
        
        viewControllerContainer.view.backgroundColor = .gray
        
        viewControllerContainer.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewControllerContainer.view.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 0),
            viewControllerContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            viewControllerContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            viewControllerContainer.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
        ])
    }
    
    func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }

}
