//
//  PlayerViewController-Swift.swift
//  AVPlayerAdapterExample
//
//  Created by Enrique Alfonso Burillo on 05/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

import UIKit
import YouboraAVPlayerAdapter
import YouboraConfigUtils
import AVKit

class PlayerViewControllerSwift: UIViewController {
    
    @objc var resourceUrl = String()

    var playerViewController:AVPlayerViewController? = nil;
    //var adapter = YBAVPlayerAdapter()
    var wrapper:YBAVPlayerAdapterSwiftWrapper? = nil;
    var youboraPlugin:YBPlugin? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.appWillResignActive), name: UIApplication.willResignActiveNotification, object:nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object:nil)
        
        // Set Youbora log level
        YBLog.setDebugLevel(.verbose)
        
        self.navigationController?.hidesBarsOnTap = true
        
        // Create Youbora plugin
        let options = YouboraConfigManager.getOptions()
        options?.offline = false
        youboraPlugin = YBPlugin.init(options: options)
        
        // Send init - this creates a new view in Youbora
        self.youboraPlugin?.fireInit()
        
        // Video player controller
        self.playerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChild(playerViewController!)
        self.view.addSubview((self.playerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.playerViewController?.view.frame = self.view.frame
        
        // Create AVPlayer
        self.playerViewController?.player = AVPlayer(url: NSURL.init(string: self.resourceUrl)! as URL)
        
        // As soon as we have the player instance, create an Adapter to listen for the player events
        startYoubora()
        
        // Start playback
        playerViewController?.player?.play()
        
        // Uncomment this to test changing the rate
        //playerViewController?.player?.rate = 1.5;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startYoubora(){
        self.wrapper = YBAVPlayerAdapterSwiftWrapper.init(adapter: adapter, andPlugin: self.youboraPlugin)
        //self.wrapper = YBAVPlayerAdapterSwiftWrapper.init(player: self.playerViewController?.player, andPlugin: self.youboraPlugin!)
    }
    
    @objc func appWillResignActive(notification: NSNotification){
        self.wrapper?.removeAdapter()
    }
    
    @objc func appDidBecomeActive(notification: NSNotification){
        self.startYoubora()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.wrapper?.removeAdapter()
        super.viewWillDisappear(animated)
    }
    
}
