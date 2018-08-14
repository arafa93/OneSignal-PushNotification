//
//  AppDelegate.swift
//  worker
//
//  Created by Mohamed Arafa on 8/4/18.
//  Copyright © 2018 Swaqny. All rights reserved.
//

import UIKit
import CoreData
import OneSignal
import SwiftyJSON



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    let AcceptedAndDoneVc = AcceptedAndDoneVC()
    let RecieveInvoiceVc = RecieveInvoiceVC()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
   
        // For debugging
        //OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        
        // -- Mark OutPut
        /*
             Received Notification: Optional("f8331601-c549-4332-9b36-50d9456c2c0b")
             launchURL = None
             content_available = true
             Message = Optional("Tech Confirm your order")
             badge number = 0
             notification sound = default
             additionalData = [AnyHashable("identifier"): RecieveInvoiceVc]
             actionSelected = []
         */

        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }

        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body)")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData = \(additionalData)")
                
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                }
                
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    
                    // For presenting a ViewController from push notification action button
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let instantiateRedViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "AcceptedAndDoneVc") as UIViewController
                    let instantiatedGreenViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "RecieveInvoiceVc") as UIViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    
                    print("actionID = \(actionID)")
                    
                    // This block gets called when the user reacts to a notification received
                    let payload: OSNotificationPayload = result!.notification.payload
                    
                    print("Payload contains all of properties in notif is : " , payload)
                    print("Payload additionalData : " , payload.additionalData)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                        //Go to messages
                        NotificationCenter.default.post(name: Notification.Name("AcceptedAndDoneVc"), object: nil)
                        
                        
                    }
                    
                    
                    if actionID == "id2" {
                        print("do something when button 2 is pressed")
                        self.window?.rootViewController = instantiateRedViewController
                        self.window?.makeKeyAndVisible()
                        
                        
                    } else if actionID == "id1" {
                        print("do something when button 1 is pressed")
                        self.window?.rootViewController = instantiatedGreenViewController
                        self.window?.makeKeyAndVisible()
                        
                    }
                }
            }
        }

        //for Push Notifications
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ]
        
        // Add your AppDelegate as an obsserver
        //OneSignal.add(self as! OSPermissionObserver)
        
        //OneSignal.add(self as! OSSubscriptionObserver)
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions, appId: "67b34326-6383-497f-86a4-fb08d3d0e628", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        return true
    }
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    

    // TODO: update docs to change method name
    // Add this new method
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    // Output:
    
    /*
         Message = Optional("Customer waiting your response on his order")
         badge number = 0
         notification sound = default
         additionalData = [AnyHashable("identifier"): RecieveInvoiceVc]
         actionSelected = []
     */
    
    

    



    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "worker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


