//
//  SplashViewController.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 29/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var categoryId = 0
    var PostId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       SetRootView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         
    }
    func SetRootView() {
        
        
        let PostId = UserDefaults.contains("PostId")
        
        if PostId
        {
            
            let pID = UserDefaults.standard.object(forKey: "PostId") as! Int
            let CommentId = UserDefaults.standard.object(forKey: "CommentId") as! Int
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "CommentId")
            UserDefaults.standard.removeObject(forKey: "PostId")
            UserDefaults.standard.synchronize()
            
          
            
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                else {
                    return
            }
            let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            
            Home.categoryId = CommentId ?? 0//0
            Home.PostId = pID ?? 0
            //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
            let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
            navigationController.isNavigationBarHidden = true
            
            sceneDelegate.window?.makeKeyAndVisible()
            
            sceneDelegate.window?.rootViewController = navigationController
            navigationController.viewControllers = [Home]
            
            //
            // App Is terminated
        }
        else
        {
            // Normal Floe

            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
              return
            }
            // let sceneDelegate = windowScene.delegate as? SceneDelegate
            let Home = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        //mainStoryboard.instantiateViewController(withIdentifier: aStoryBoardID)
                        let navigationController : UINavigationController = UINavigationController(rootViewController: Home)
                        navigationController.isNavigationBarHidden = true
                        //navigationController.navigationBar.barTintColor = UIColor.init(hexString: "197197")
                    //    self.window?.makeKeyAndVisible()
            sceneDelegate.window?.makeKeyAndVisible()
            sceneDelegate.window?.rootViewController = navigationController
            //SceneDelegate.shared.window.rootViewController = navigationController
                        navigationController.viewControllers = [Home]
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UserDefaults {
    static func contains(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
