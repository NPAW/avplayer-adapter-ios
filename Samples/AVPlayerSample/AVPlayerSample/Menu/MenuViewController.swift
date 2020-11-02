//
//  MenuViewController.swift
//  AVPlayerSample
//
//  Created by Tiago Pereira on 17/09/2020.
//  Copyright © 2020 NicePeopleAtWork. All rights reserved.
//

import UIKit
import YouboraConfigUtils
import YouboraLib

class MenuViewController: UIViewController {
    
    @IBOutlet var resourceTextField: UITextField!
    @IBOutlet var adsToggle: UISwitch!
    @IBOutlet var playButton: UIButton!
    
    var plugin: YBPlugin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YBLog.setDebugLevel(.debug)
        
        self.addSettingsButton()
        
        self.resourceTextField.text = Resource.hlsApple
        self.adsToggle.isOn = false
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
    
    @IBAction func pressToSendOfflineEvents(_ sender: UIButton) {
        let options = YouboraConfigManager.getOptions()
        options.offline = false
        
        self.plugin = YBPlugin(options: options)
        
        for _ in 1...3 {
            self.plugin?.fireOfflineEvents()
        }
    }
    
    @IBAction func pressButtonToNavigate(_ sender: UIButton) {
        if sender == self.playButton {
            let playerViewController = PlayerViewController()
            
            playerViewController.resource = self.resourceTextField.text
            playerViewController.containAds = self.adsToggle.isOn
            
            navigateToViewController(viewController: playerViewController)
            return
        }
    }
    
    @objc func navigateToSettings() {
        guard let _ = self.navigationController else {
            navigateToViewController(viewController:
                YouboraConfigViewController.initFromXIB(animatedNavigation: false))
            return
        }
        
        navigateToViewController(viewController: YouboraConfigViewController.initFromXIB())
    }
    
    func navigateToViewController(viewController: UIViewController) {
        guard let navigationController = self.navigationController else {
            self.present(viewController, animated: true, completion: nil)
            return
        }

        navigationController.pushViewController(viewController, animated: true)
    }
}
