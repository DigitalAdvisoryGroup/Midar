//
//  SceneDelegate.swift
//  XMLRPCDemo
//

//

import UIKit
import UserNotifications
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let bool = UserDefaults.contains("VerifyOTP")
      
        if bool
        {
            print("bool:-",bool)
            
            let PostId = UserDefaults.contains("PostId")
            
            if PostId
            {
                let CommentId =   UserDefaults.standard.object(forKey: "CommentId") as! Int
                let PostId =   UserDefaults.standard.object(forKey: "PostId")  as! Int
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                              print("done")
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

                       
                                          })
                      
            }
            else
            {
                let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                            let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                            navigationController.isNavigationBarHidden = true
                            //navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                        //    self.window?.makeKeyAndVisible()
               self.window?.makeKeyAndVisible()
                self.window?.rootViewController = navigationController
                //SceneDelegate.shared.window.rootViewController = navigationController
                            navigationController.viewControllers = [Home]
                
                /*
                let Home = STORYBOARD.Launch.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                                                //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                                                let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                                                navigationController.isNavigationBarHidden = true
                                                //navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                                                self.window?.makeKeyAndVisible()
                                                
                               self.window?.rootViewController = navigationController
                                                navigationController.viewControllers = [Home] */
            }
            
            
            //+ 1.0
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                       print("done")
//
//
//                   })
//
//
            
//            let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
//            let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
//            navigationController.isNavigationBarHidden = true
//            //navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
//            self.window?.makeKeyAndVisible()
//
//            window?.rootViewController = navigationController
//            navigationController.viewControllers = [Home]
        }
        else
        {
            
        }
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
    }
    
    
}

