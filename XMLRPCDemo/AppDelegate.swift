//
//  AppDelegate.swift
//  XMLRPCDemo
//
//  Created by Nyusoft on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        IQKeyboardManager.shared.enable = true

        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in  })
            // Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        
        Messaging.messaging().delegate = self
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        
        
        // Override point for customization after application launch.
        let bool = UserDefaults.contains("VerifyOTP")
        
//        PostId:-
//        CommentId:-
        
        UserDefaults.standard.removeObject(forKey: "CommentId")
        UserDefaults.standard.removeObject(forKey: "PostId")
        UserDefaults.standard.synchronize()
        
        
//        UserDefaults.standard.set(230, forKey: "CommentId")
//                 UserDefaults.standard.set(22, forKey: "PostId")
//
       /*
        if bool
        {
            print("bool:-",bool)
            
            let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
            let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
            navigationController.isNavigationBarHidden = true
            //  navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
            navigationController.viewControllers = [Home]
            window?.rootViewController = navigationController
        }
        else
        {
            print("bool:-",bool)
        }*/
        return true
    }
   
    
    
    // MARK: FireBase Push Notification Method
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "DevcieToken")
        //      let dataDict:[String: String] = ["token": fcmToken]
        //      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        print("APPDelegateNotificationResponse:-",userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//
//
//    }
//    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//
//        print("APPDelegateRecived: \(userInfo)")
//
//        completionHandler(.newData)
//
//    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationData = response.notification.request.content.userInfo
        
         print("APPDelegateRecived: \(notificationData)")
        
       guard let arrAPS = notificationData["aps"] as? [String: Any] else { return }
          print("arrAPS:-",arrAPS)
        let cat = arrAPS["category"] ?? "" //as? [String: NSDictionary]//[String: Any] else { return }
      //
          let strcat = "\(String(describing: cat))"
         print("category:-",cat)
        if strcat == "0"
        {
            // Home Screeen

                  let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                  Home.categoryId = CommentId ?? 0//0
//                  Home.PostId = PostId ?? 0
            //  window = UIWindow(frame: UIScreen.main.bounds)
              
                            //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                            let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                            navigationController.isNavigationBarHidden = true
                            //  navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                           self.window?.makeKeyAndVisible()
                              self.window?.rootViewController = navigationController
                            navigationController.viewControllers = [Home]
              
              
        }
        else
        {
            // Replay Comment VC
            let array = strcat.components(separatedBy: ",")
                  print("PostId:-",array[0])
                  print("CommentId:-",array[1])
                let PostId = Int(array[0])
                  let CommentId = Int(array[1])
                  
                  UserDefaults.standard.set(CommentId, forKey: "CommentId")
                    UserDefaults.standard.set(PostId, forKey: "PostId")
                  
                  
                      let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                      Home.categoryId = CommentId ?? 0//0
                      Home.PostId = PostId ?? 0
                //  window = UIWindow(frame: UIScreen.main.bounds)
                  
                                //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                                let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                                navigationController.isNavigationBarHidden = true
                                //  navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                               self.window?.makeKeyAndVisible()
                                  self.window?.rootViewController = navigationController
                                navigationController.viewControllers = [Home]
                  
        }
        
        
//        let categorydict = arrAPS["category"] as? NSDictionary
//        print("categorydict:-",categorydict)
       //[""])
      
      
         
      
        
        
        
              /*  window = UIWindow(frame: UIScreen.main.bounds)
               let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
               let vc = storyboard.instantiateInitialViewController() as! SplashViewController
               vc.categoryId = CommentId ?? 0//0
                vc.PostId = PostId ?? 0
             
               window?.rootViewController = vc
               window?.makeKeyAndVisible() */
        
       /* let Home = STORYBOARD.Launch.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                       Home.categoryId = CommentId ?? 0//0
                                          Home.PostId = PostId ?? 0
                                             //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                                             let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                                             navigationController.isNavigationBarHidden = true
                                             //navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                                             self.window?.makeKeyAndVisible()
                                             
                                             window?.rootViewController = navigationController
                                             navigationController.viewControllers = [Home]
        
        */
        
      /*  if let topVC = UIApplication.topViewController(){
            if topVC is HomeViewController
              {
                    let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    Home.categoryId = CommentId ?? 0//0
                    Home.PostId = PostId ?? 0
                              //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                              let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                              navigationController.isNavigationBarHidden = true
                              //  navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                             self.window?.makeKeyAndVisible()
                                self.window?.rootViewController = navigationController
                              navigationController.viewControllers = [Home]
                    
            }
            else
            {
                let Home = STORYBOARD.Launch.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                Home.categoryId = CommentId ?? 0//0
                                   Home.PostId = PostId ?? 0
                                      //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                                      let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                                      navigationController.isNavigationBarHidden = true
                                      //navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                                      self.window?.makeKeyAndVisible()
                                      
                                      window?.rootViewController = navigationController
                                      navigationController.viewControllers = [Home]
            }
        } */
  
         // DispatchQueue.main.async {
            
           
             completionHandler()
     //   }
        
        
        
        // Use this data to present a view controller based
        // on the type of notification received
      
    } 

    
//    func application(_ application: UIApplication,
//                             didReceiveRemoteNotification userInfo: [AnyHashable : Any],
//                             fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//            completionHandler(.newData)
//    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

