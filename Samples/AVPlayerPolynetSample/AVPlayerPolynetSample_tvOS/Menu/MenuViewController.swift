//
//  MenuViewController.swift
//  AVPlayerPolynetSample_tvOS
//
//  Created by Tiago Pereira on 18/09/2020.
//  Copyright © 2020 NicePeopleAtWork. All rights reserved.
//

import UIKit
import YouboraConfigUtils

class MenuViewController: UIViewController {
    
    @IBOutlet var resourceTextField: UITextField!
    @IBOutlet var adsSegmentedControl: UISegmentedControl!
    @IBOutlet var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSettingsButton()
        
        self.resourceTextField.text = "https://s73-streams.s3.amazonaws.com/sintel/manifest.m3u8"
        self.adsSegmentedControl.selectedSegmentIndex = 0
    }
    
    public static func initFromXIB() -> MenuViewController? {
        return MenuViewController(
            nibName: String(describing: MenuViewController.self),
            bundle: Bundle(for: MenuViewController.self))
    }

}

// MARK: - Settings Section

extension MenuViewController {
    func addSettingsButton() {
        guard let navigationController = self.navigationController else {
            return
        }
        
        addSettingsToNavigation(navigationBar: navigationController.navigationBar)
    }
    
    func addSettingsToNavigation(navigationBar: UINavigationBar) {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(navigateToSettings))
        navigationBar.topItem?.rightBarButtonItem = settingsButton
    }
}

// MARK: - Navigation Section

extension MenuViewController {
    
    @IBAction func pressButtonToNavigate(_ sender: UIButton) {
        if sender == self.playButton {
            let playerViewController = PlayerViewController()
            
            playerViewController.resource = self.resourceTextField.text
            playerViewController.containAds = self.adsSegmentedControl.selectedSegmentIndex == 0 ? false : true
            
            navigateToViewController(viewController: playerViewController)
            return
        }
    }
    
    @objc func navigateToSettings() {
        let configViewController = YouboraConfigViewController.initFromXIB()
         
        guard let navigationController = self.navigationController else {
            self.present(configViewController, animated: true, completion: nil)
            return
        }
        navigationController.show(configViewController, sender: nil)
    }
    
    func navigateToViewController(viewController: UIViewController) {
        guard let navigationController = self.navigationController else {
            self.present(viewController, animated: true, completion: nil)
            return
        }

        navigationController.pushViewController(viewController, animated: true)
    }
}
