//
//  SceneDelegate.swift
//  study
//
//  Created by Reksagon on 3/5/24.
//

import Foundation
import UIKit

import FBSDKCoreKit
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        setupATTracking()
        setupAppsFlyer()
        configureAppsFlyer()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    private func setupATTracking() {
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        FirebaseReportService.sendCustomEvent(.at_tracking, parameters: ["status": "authorized"])
                    default:
                        FirebaseReportService.sendCustomEvent(.at_tracking, parameters: ["status": "denied"])
                    }
                }
            }
            print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
        }
    }
    
    //MARK: AppsFlyer Methods
    private func configureAppsFlyer() {
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        let customUserId = UserDefaults.standard.string(forKey: "customUserId")
        
        if(customUserId != nil && customUserId != "") {
            // Set CUID in AppsFlyer SDK for this session
            AppsFlyerLib.shared().customerUserID = customUserId
        }
        AppsFlyerLib.shared().start()
    }
    
    private func setupAppsFlyer() {
        AppsFlyerLib.shared().appsFlyerDevKey = "rqDHZ4L9UtiScxTR3QUdjT"
        AppsFlyerLib.shared().appleAppID = "6494938400"
        AppsFlyerLib.shared().delegate = self
#if DEBUG
        AppsFlyerLib.shared().isDebug = true
#endif
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        
    }

}

extension SceneDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionData: [AnyHashable: Any]) {
        print("conversionData: \(conversionData)")
        if let campaign = conversionData["campaign"] as? String {
            print("Campaign name: \(campaign)")
            let components = campaign.split(separator: "_").map(String.init)
            
            if components.count > 6 {
                let domain = "https://\(components[0]).com/\(components[2])"
                let sub2 = components[3]
                let sub3 = components[4]
                let sub4 = components[5]
                let at = components[6]
                let tkn = components.last?.split(separator: "&").map(String.init).last ?? ""
                
                var urlComponents = URLComponents(string: domain)
                urlComponents?.queryItems = [
                    URLQueryItem(name: "sub_2", value: sub2),
                    URLQueryItem(name: "sub_3", value: sub3),
                    URLQueryItem(name: "sub_4", value: sub4),
                    URLQueryItem(name: "at", value: at),
                    URLQueryItem(name: "tkn", value: tkn)
                ]
                
                if let url = urlComponents?.url {
                    ViewController.namingUrl = url.absoluteString
                }
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        print("Attribution data: \(attributionData)")
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print("Attribution error: \(error.localizedDescription)")
    }
}



