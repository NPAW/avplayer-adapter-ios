//
//  MenuViewController.swift
//  SeveralUtils
//
//  Created by nice on 21/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import UIKit
import YouboraConfigUtils

@objcMembers class MenuViewController: UIViewController {
    @IBOutlet weak var resourcesTableView: UITableView!
    @IBOutlet weak var resourceTextField: UITextField!
    
    @IBOutlet weak var noAvailableAds: UIView!
    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var adTextField: UITextField!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var settingsContainer: UIView!
    
    @IBOutlet weak var previousConfigView: UIView!
    @IBOutlet weak var nextConfigView: UIView!
    
    var viewModel = MenuViewModel()
    
    var configViews: [UIView] = []
    
    var currentConfigView = 0 {
        didSet {
            self.updateConfigView()
        }
    }
    
    static func initFromXIB() -> MenuViewController {
        let viewController = MenuViewController()
        
        let className = String(describing: type(of: viewController))
        let bundle = Bundle(for: viewController.classForCoder)
        
        return MenuViewController(nibName: className, bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSettingsButton()
        self.registerLinksTableView()
        self.setupAdsElements()
        self.addLanguageSelection()
        self.registerConfigViews()
    }

    @IBAction func onTextFieldEditing(_ sender: UITextField) {
        if sender == self.resourceTextField {
            self.viewModel.updateResourceLink(newLink: self.resourceTextField.text)
        }
        if sender == self.adTextField {
            self.viewModel.updateAdLink(newLink: self.adTextField.text)
        }
    }
}


// MARK: - Table view delegate and source
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.resourcesTableView {
            return viewModel.getNumberOfResources()
        }
        
        if tableView == self.adsTableView {
            return viewModel.getNumberOfAds()
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.resourcesTableView {
            guard let cell = dequeueReusableResourceCell(tableView: tableView, indexPath: indexPath) else {
                return UITableViewCell(style: .default, reuseIdentifier: "Default")
            }
            cell.viewModel = viewModel.getVRViewModel(position: indexPath.row)
            return cell
        }
        
        if tableView == self.adsTableView {
            guard let cell = dequeueReusableAdCell(tableView: tableView, indexPath: indexPath) else {
                return UITableViewCell(style: .default, reuseIdentifier: "Default")
            }
            
            cell.viewModel = viewModel.getAdViewModel(position: indexPath.row)
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "Default")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.resourcesTableView {
            self.viewModel.didSelectNewResource(position: indexPath.row)
        }
        
        if tableView == self.adsTableView {
           self.viewModel.didSelectNewAd(position: indexPath.row)
        }
    }
}

// MARK: - Video Resource Section
extension MenuViewController {
    func registerLinksTableView() {
        self.resourcesTableView.delegate = self
        self.resourcesTableView.dataSource = self
        
        VideoResourceTableViewCell().registerCell(tableView: self.resourcesTableView)
        
        self.resourceTextField.text = viewModel.selectedResource.resourceLink
        
        viewModel.selectedResourceDidUpdate = { [weak self] in
            self?.resourceTextField.text = self?.viewModel.selectedResource.resourceLink
        }
    }
    
    func dequeueReusableResourceCell(tableView: UITableView, indexPath: IndexPath) -> VideoResourceTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell().customIdentifier, for: indexPath) as? VideoResourceTableViewCell else {
            return VideoResourceTableViewCell().initFromXib() as? VideoResourceTableViewCell
        }
        
        return cell
    }
}

// MARK: - Ads Section
extension MenuViewController {
    func setupAdsElements() {
        if !self.viewModel.areThereAds() { return }
        
        self.noAvailableAds.isHidden = true
        
        self.adsTableView.delegate = self
        self.adsTableView.dataSource = self
        
        AdTableViewCell().registerCell(tableView: self.adsTableView)
        
        self.setSelectCurrentAd()
        
        self.adTextField.text = self.viewModel.selectedAd?.adLink
        viewModel.selectedAdDidUpdate = { [weak self] in
            self?.adTextField.text = self?.viewModel.selectedAd?.adLink
        }
    }
    
    func setSelectCurrentAd() {
        guard let currentAdPosition = self.viewModel.getCurrentAdPosition() else {
            return
        }

        self.adsTableView.selectRow(at: IndexPath(row: currentAdPosition, section: 0), animated: false, scrollPosition: .middle)
    }
    
    func dequeueReusableAdCell(tableView: UITableView, indexPath: IndexPath) -> AdTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell().customIdentifier, for: indexPath) as? AdTableViewCell else {
            return VideoResourceTableViewCell().initFromXib() as? AdTableViewCell
        }

        return cell
    }
}

// MARK: - Settings Section

extension MenuViewController {
    func addSettingsButton() {
        guard let navigationController = self.navigationController else {
            return
        }
        
        self.settingsButton.isHidden = true
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
            playerViewController.viewModel = self.viewModel.getPlayerViewModel()
            navigateToViewController(viewController: playerViewController)
            return
        }
        
        if sender == self.settingsButton {
            navigateToSettings()
            return
        }
    }
    
    func navigateToSettings() {
        guard let _ = self.navigationController else {
            navigateToViewController(viewController: ConfigContainerViewController().initFromXIB())
            return
        }
        
        navigateToViewController(viewController: YouboraConfigViewController())
    }
    
    
    
    func navigateToViewController(viewController: UIViewController) {
        guard let navigationController = self.navigationController else {
            self.present(viewController, animated: true, completion: nil)
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

//MARK: Configuration views section
extension MenuViewController {
    func registerConfigViews() {
        self.previousConfigView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPreviousConf)))
        self.nextConfigView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNextConf)))
        updateConfigView()
    }
    
    @objc func showPreviousConf(sender:UITapGestureRecognizer) {
        if self.currentConfigView > 0 {
            self.currentConfigView = self.currentConfigView - 1
        }
    }
    
    @objc func showNextConf(sender:UITapGestureRecognizer) {
        if self.currentConfigView < self.configViews.count - 1{
            self.currentConfigView = self.currentConfigView + 1
        }
    }
    
    func updateConfigView() {
        if self.configViews.isEmpty { return }
        
        for view in self.settingsContainer.subviews {
            view.removeFromSuperview()
        }
        
        let newView = self.configViews[self.currentConfigView]
        self.settingsContainer.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: self.settingsContainer.topAnchor),
            newView.bottomAnchor.constraint(equalTo: self.settingsContainer.bottomAnchor),
            newView.trailingAnchor.constraint(equalTo: self.settingsContainer.trailingAnchor),
            newView.leadingAnchor.constraint(equalTo: self.settingsContainer.leadingAnchor)
        ])
    }
}

//MARK: Languages Section
extension MenuViewController: LanguageConfigViewDelegate {
    func addLanguageSelection() {
        let languagesSelectionView = LanguageConfigView().initFromXIB()
        languagesSelectionView.delegate = self
        languagesSelectionView.selectSegmentIndex(index: self.viewModel.selectedLanguage.rawValue)
        
        self.configViews.append(languagesSelectionView)
    }
    
    func languageIndexDidChange(newIndex: Int) {
        self.viewModel.didSelectedNewLanguage(languageIndex:newIndex)
    }
}
