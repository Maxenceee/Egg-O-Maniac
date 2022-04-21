//
//  AppDelegate.swift
//  EggTimer
//
//  Created by Gama Maxence on 08/07/2019.
//
/*
                                               __  __                             ___
                                              |  \/  |__ ___ _____ _ _  __ ___   / __|__ _ _ __  __ _
                                              | |\/| / _` \ \ / -_) ' \/ _/ -_) | (_ / _` | '  \/ _` |
                                              |_|  |_\__,_/_\_\___|_||_\__\___|  \___\__,_|_|_|_\__,_|
                      
   
*/

import UIKit
import UserNotifications
import SwiftUI
import CoreData
import Firebase
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForPushNotifications(application: application)
        UNUserNotificationCenter.current().delegate = self
        
        
        //Initialize Firebase
        FirebaseApp.configure()
        
        //Initialize AdMob
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-1041974861753876~3781805094")
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        requestIDFA()
        
        //UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        // Define Actions
        //let endTimerAction = UNNotificationAction(identifier: "endTimerAction", title: "Timer ended", options: [])
        
        // Define category
        //let category = UNNotificationCategory(identifier: "eggCategory", actions: [endTimerAction], intentIdentifiers: [], options: [])
        
        //UNUserNotificationCenter.current().setNotificationCategories([category])
        
//        Thread.sleep(forTimeInterval: 1.0)
        return true
    }
    
    func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WatchKitSaysHello"), object: userInfo)
    }
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
        // loadAd()
      })
    }
    
    func scheduleNotification(timeInterval: Int) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "C'est cuit !".localized()
        content.body = "Ça y est vos oeufs sont prêts. Votre minuteur est terminé.\nBon appétit !".localized()
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Cool-alarm-tone-notification-sound.mp3"))
        content.categoryIdentifier = "EOM-N-Cat"
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: "timerAsEnded", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: -UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func registerForPushNotifications(application: UIApplication) -> () {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
          granted, error in
          print("Permission granted: \(granted)")
      }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
}

