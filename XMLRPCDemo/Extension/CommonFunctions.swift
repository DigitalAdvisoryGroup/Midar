//
//  CommonFunctions.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation
import MBProgressHUD
import SwiftyJSON

class CommonFunction: NSObject {
    
    static let Instance = CommonFunction()
    
    //MARK: - MBProgressBar
    func displayProgressBar(){
        MBProgressHUD.showAdded(to: (APPDELEGATE.window?.rootViewController?.view)!, animated: true)
    }
    func hideProgressBar(){
        MBProgressHUD.hide(for: (APPDELEGATE.window?.rootViewController?.view)!, animated: false)
    }
    
    //MARK: - RootViewController Functions
    //Declare enum
    enum AnimationType{
        case ANIMATE_RIGHT
        case ANIMATE_LEFT
        case ANIMATE_UP
        case ANIMATE_DOWN
    }
    // Create Function...
    
    func showViewControllerWith(newViewController:UIViewController, usingAnimation animationType:AnimationType)
    {
        
        let currentViewController = APPDELEGATE.window?.rootViewController
        let width = currentViewController?.view.frame.size.width;
        let height = currentViewController?.view.frame.size.height;
        
        var previousFrame:CGRect?
        var nextFrame:CGRect?
        
        switch animationType
        {
            
        case .ANIMATE_LEFT:
            previousFrame = CGRect(x: width!-1, y: 0.0, width: width!, height: height!)
            nextFrame = CGRect(x: -width!, y: 0.0, width: width!, height: height!)
        case .ANIMATE_RIGHT:
            previousFrame = CGRect(x: -width!+1, y: 0.0, width: width!, height: height!)
            nextFrame = CGRect(x: width!, y: 0.0, width: width!, height: height!)
        case .ANIMATE_UP:
            previousFrame = CGRect(x: 0.0, y: height!-1, width: width!, height: height!)
            nextFrame = CGRect(x: 0.0, y:  -height!+1, width: width!, height: height!)
        case .ANIMATE_DOWN:
            previousFrame = CGRect(x: 0.0, y:  -height!+1, width: width!, height: height!)
            nextFrame = CGRect(x: 0.0, y: height!-1, width: width!, height: height!)
        }
        
        newViewController.view.frame = previousFrame!
        APPDELEGATE.window?.addSubview(newViewController.view)
        
        UIView.animate(withDuration: 0.33,
                       animations: { () -> Void in
                        newViewController.view.frame = (currentViewController?.view.frame)!
                        currentViewController?.view.frame = nextFrame!
                        
        })
        { (fihish:Bool) -> Void in
            APPDELEGATE.window?.rootViewController = newViewController
        }
    }
    
    func showViewControllerWithFadeEffect(newViewController:UIViewController, window : UIWindow)
    {
        
        let currentViewController = window.rootViewController
        window.addSubview(newViewController.view)
        
        currentViewController?.view.alpha = 1
        newViewController.view.alpha = 0
        
        UIView.animate(withDuration: 0.33,
                       animations: { () -> Void in
                        currentViewController?.view.alpha = 0
                        newViewController.view.alpha = 1
                        
        })
        { (fihish:Bool) -> Void in
            window.rootViewController = newViewController
        }
        
    }
    
    //Call to Mobile Number
    func callToNumber(phone : String){
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func stringWithImage(image: UIImage ,value: String) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attachmentString = NSAttributedString(attachment: attachment)
        let imageOffsetY:CGFloat = -3.0;
        attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
        myString.append(NSMutableAttributedString(string: " \(value)"))
        return myString
    }
    //For change btnColor
    func getBtn(btn: UIButton, image : UIImage, color: UIColor) {
        let tempImage = image.withRenderingMode(.alwaysTemplate)
        btn.setImage(tempImage, for: .normal)
        btn.tintColor = color
    }
//
//    /// To logout current user
//    func performLogout() {
//        //Logout From Server
//        //APPDELEGATE.callLogoutService()
//
//        let objUser = User.loadLoggedInUser()
//        objUser?.deleteUser()
//        //APPDELEGATE.handleAppViewControllerFlow(wind: APPDELEGATE.window!)
//        UserProfileManager.shared.handleAppViewControllerFlow(wind: APPDELEGATE.window!)
//    }
    
    //Get Current Tapped Index from Section Indexpath tableview
    func returnPositionForThisIndexPath(indexPath:IndexPath, insideThisTable theTable:UITableView)->Int{
        var i = 0
        var rowCount = 0
        while i < indexPath.section {
            rowCount += theTable.numberOfRows(inSection: i)
            i += 1
        }
        rowCount += indexPath.row
        return rowCount
    }
    
    func getImageFromUrl(strUrl: String) -> UIImage {
        let url = URL(string: strUrl)
        if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data) ?? UIImage()
        } else {
            return UIImage()
        }
    }
    
  /*  func TblEmptyMessage(message: String = "No record found!", tableView: UITableView, font: UIFont = UIFont.boldSystemFont(ofSize: 20)) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message.localized()
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = font
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel;
    } */
    
    /*func CVEmptyMessage(message: String = "No record found!", collectionView: UICollectionView, font: UIFont = UIFont.boldSystemFont(ofSize: 20)) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message.localized()
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = font
        messageLabel.sizeToFit()
        collectionView.backgroundView = messageLabel;
    } */
}
