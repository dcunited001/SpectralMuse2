//
//  AppDelegate.swift
//  SpectralMuse
//
//  Created by David Conner on 2/27/16.
//  Copyright © 2016 Spectra. All rights reserved.
//

import UIKit
import Synchronized

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var muse: IXNMuse?
    var muz0r: IXNMuseManager!
    var museTimer: NSTimer?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        return true
    }
    
//    func app

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // TODO: fix synchronized call (it doesn't work with optionals)
//        synchronized(self.muz0r) {
            // lock muz0r and make sure it's set
            if (self.muz0r != nil) {
                return
            } else {
                // WTF: swift can't even!
                self.muz0r = LibMuse.getSharedManager()
            }
//        }
        
        if self.muse == nil {
            self.museTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("showPicker"), userInfo: nil, repeats: false)
        }
        
        // if (!self.loggingListener)
        
        let nsKeyOptions = NSKeyValueObservingOptions(
            rawValue: NSKeyValueObservingOptions.New.rawValue |
                NSKeyValueObservingOptions.Initial.rawValue)
        
        self.muz0r.addObserver(self,
            forKeyPath: self.muz0r.connectedMusesKeyPath(),
            options: nsKeyOptions,
            context: nil)
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func showPicker() {
        self.muz0r?.showMusePickerWithCompletion { err in
            if (err != nil) {
                print("Error showing Muse picker: \(err?.description)")
            }
        }
    }
    
    func startWithMuse(muse: IXNMuse) {
        // TODO: fix synchronization issues
        // @synchronized (self.muse) {
        guard let m = self.muse else {
            return
        }
        
        self.muse = muse
        self.museTimer!.invalidate()
        self.museTimer = nil;
//        [self.muse registerDataListener:self.loggingListener
//            type:IXNMuseDataPacketTypeArtifacts];
//        [self.muse registerDataListener:self.loggingListener
//            type:IXNMuseDataPacketTypeBattery];
//        [self.muse registerDataListener:self.loggingListener
//            type:IXNMuseDataPacketTypeAccelerometer];
//        [self.muse registerConnectionListener:self.loggingListener];
        self.muse!.runAsynchronously()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == self.muz0r.connectedMusesKeyPath()) {
            let connectedMuses = change![NSKeyValueChangeNewKey]!
            if (connectedMuses.count > 0) {
                let selectedMuse = connectedMuses.anyObject() as! IXNMuse
                // example uses #anyObject method from objective-c
                self.startWithMuse(selectedMuse)
            }
        }
    }
    
    func sayHi() {
        let alert = UIAlertView(title: "Helloz", message: "Muse is connect you", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}

