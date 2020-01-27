//
//  ViewController.swift
//  AvPlayerPolynetAdapterExample-tvOS
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

import UIKit
import AVFoundation
import YouboraConfigUtils
import PolyNetSDK

class ViewController: UIViewController {
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "PolyNet SDK sample app menu"
        loadFromPersistance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playButton.setTitle("Play!", for: .normal)
        playButton.isEnabled = true
        
        self.updateVersionLabel()
    }
    
    // MARK: User defaults
    
    fileprivate let MANIFEST_URL_KEY = "MANIFEST_URL_KEY"
    fileprivate let CHANNEL_ID_KEY = "CHANNEL_ID_KEY"
    fileprivate let API_KEY_KEY = "API_KEY_KEY"
    fileprivate let FIRST_SECTION_HEADER_HEIGHT = CGFloat(40.0)
    fileprivate let SECTION_HEADER_HEIGHT = CGFloat(12.0)
    
    fileprivate func loadFromPersistance() {
        manifestUrlTextField.text = PolynetConstants.POLYNET_RESOURCE_ULR
        channelIdTextField.text = ""
        apiKeyTextField.text = PolynetConstants.POLYNET_KEY
    }
    
    fileprivate func updateVersionLabel() {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            return
        }
        
        versionLabel.text = String(format: "Sample App v%@-%@\nPolyNet SDK v.%@",
                                   dict["CFBundleVersion"] as! String,
                                   dict["CFBundleShortVersionString"] as! String,
                                   PolyNet.frameworkVersion)
    }
    
    // MARK: IBActions and IBOutlets
    
    @IBOutlet weak var manifestUrlTextField: UITextField!
    @IBOutlet weak var channelIdTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBAction func pressOnSettings(_ sender: Any) {
        self.present(YouboraConfigViewController.initFromXIB(), animated: false, completion: nil)
    }
    
    @IBAction func playButtonActionTriggered(_ sender: Any) {
        // Remove White Spaces
        removeWhiteSpaces()
        
        // UI
        playButton.isEnabled = false
        playButton.setTitle("Connecting to PolyNet", for: .normal)
        
        let playerViewController = PlayerViewController()
        
        playerViewController.manifestUrl = self.manifestUrlTextField.text
        playerViewController.apiKey = self.apiKeyTextField.text
        playerViewController.channelId = self.channelIdTextField.text
        
        self.navigationController?.pushViewController(playerViewController, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func removeWhiteSpaces() {
        manifestUrlTextField.text = manifestUrlTextField.text?.replacingOccurrences(of: " ", with: "")
        channelIdTextField.text = channelIdTextField.text?.replacingOccurrences(of: " ", with: "")
        apiKeyTextField.text = apiKeyTextField.text?.replacingOccurrences(of: " ", with: "")
    }
    

}
