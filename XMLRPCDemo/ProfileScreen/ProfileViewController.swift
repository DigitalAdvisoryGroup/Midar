//
//  ProfileViewController.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 05/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
//import Alamofire
class ProfileViewController: UIViewController {
    @IBOutlet var tblProfile : UITableView!
    var DataDict = [NSDictionary]()
    var Lnagstr = ""
    var ProfileFlag = ""
    var objectDict = NSDictionary()
    var partner_idINt = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile".localized()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        Lnagstr = Locale.current.languageCode!
         let code = Localize.currentLanguage()//availableLanguages(true)//[index]
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //  self.DataDict = UserDefaults.standard.object(forKey: "ProfileData") as! [NSDictionary]
        print(" self.DataDict:-", self.DataDict)
          getDataAPi()
        
        
    }
    @IBAction func btnImagesProfileAction(_ sender: Any)
    {
        
        var aryButtonName = [String]()
        aryButtonName.append("From Gallery")
        aryButtonName.append("Camera")
        self.showActionSheetWithCompletion(pTitle: "Choose Option", pStrMessage: "", arrButtonName: aryButtonName, destructiveButtonIndex: nil, strCancelButton: "Cancel".localized(), tintColor: UIColor.systemBlue, sender: nil, shouldAnimate: true) { (Int) in
            print("Int:-",Int)
            if Int == 0
            {
                //From Photos
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                self.present(vc, animated: true)
            }
            else if Int == 2
            {
                
            }
            else
            {
                //Take Picture
                print("Take Picture")
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                self.present(vc, animated: true)
                
            }
            
        }
        
        
    }
    
    func getDataAPi()  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
        var parther_ID = 0
        var params = [Any]()
        
        if ProfileFlag == ""
        {
            // Normal Profile
            parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
            params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_profile_data",[[parther_ID]]] as [Any]
            
        }
        else
        {
            //  parther_ID = objectDict.object(forKey: "partner_id") as! Int
            params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_profile_data",[[partner_idINt]]] as [Any]
        }
        
        
        
        let strUrl = "\(WebAPI.BaseURL)" + "object"
      
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            
            if let j = ObejcData as? [String:Any]{
                if let data = j["data"]{
                    //print("data:-",data)
                    self.DataDict = data as! [NSDictionary]
                    //print("DataDict:-",self.DataDict)
                    DispatchQueue.main.async {
                        self.tblProfile.reloadData()
                    }
                    
                }
            }
            //                if let data = ObejcData["data"]
            //                {
            //                      self.DataDict = data as! [NSDictionary]
            //                }
            
            //self.DataDict = ObejcData as! [NSDictionary]
            //                DispatchQueue.main.async {
            //                    self.tblProfile.reloadData()
            //                                       }
            
            
            
            
        }) { (error) in
            print("error:-",error)
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
extension ProfileViewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataDict.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        let object = DataDict[indexPath.row]
        cell.btnLan.tag = indexPath.row
        cell.btnLan.addTarget(self, action: #selector(self.LanguageOption), for: .touchUpInside)
        cell.configureCellWith(viewController: self, indexPath1: indexPath, object: object)
        cell.btnLogout.tag = indexPath.row
        cell.btnLogout.addTarget(self, action: #selector(self.logoutButton), for: .touchUpInside) //<- use `#selector(...)`
        cell.btnSubscribe.addTarget(self, action: #selector(self.subscribeAction), for: .touchUpInside) //<- use `#selector(...)`
        
        if ProfileFlag == ""
        {
            // Normal Profile
            
            cell.btnUserProfile.isUserInteractionEnabled = true
        }
        else
        {
            cell.btnLogout.isHidden = true
            cell.btnChnageConnection.isHidden = true
            cell.btnUserProfile.isUserInteractionEnabled = false
        }
        return cell
        
    }
    @objc func LanguageOption(_ sender: UIButton)
    {
    
        var aryLaguage = Localize.availableLanguages(true).map{ Localize.displayNameForLanguage($0) }
       
                let selIndex = aryLaguage.firstIndex(of: Localize.displayNameForLanguage(Localize.currentLanguage()))
        
        self.showActionSheetWithCompletion(pTitle: Localized("Select Language".localized()), pStrMessage: nil, arrButtonName: aryLaguage, destructiveButtonIndex: selIndex, strCancelButton: "Cancel".localized(), tintColor: UIColor.darkGray, shouldAnimate: true, completionBlock: { (index) in
                    if index >= aryLaguage.count { return }
                    //Change Language
           let code = Localize.availableLanguages(true)[index]
            self.LanguageAPI(langCode: "\(code)")
                   Localize.setCurrentLanguage(Localize.availableLanguages(true)[index])
                    //APPDELEGATE.handleAppViewControllerFlow()
                    
        //            self.showAlertWithCompletion(pTitle: nil, pStrMessage: "For better experience please restart app.") { (_) in
        //                Localize.setCurrentLanguage(Localize.availableLanguages(true)[index])
        //                APPDELEGATE.handleAppViewControllerFlow()
        //            }
                })
        
    }
    func LanguageAPI (langCode: String)  {
            let uid = UserDefaults.standard.object(forKey: "uid") as! Int
            let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
            //  UserDefaults.standard.set(ObejcData, forKey: "")
            
            let params = ["\(WebAPI.DBName)",uid, "\(WebAPI.Password)","res.partner","set_partner_language",[[parther_ID],langCode]] as [Any]
            
            print("paramsGetPostData:-",params)
            let url = "\(WebAPI.BaseURL)" + "object"
            KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                
                DispatchQueue.main.async {
                    let dictary = self.DataDict
                        let dict = dictary[0] as? NSDictionary
                    dict?.setValue(langCode, forKey: "lang")
                        
                   self.DataDict = dictary
                    self.tblProfile.reloadData()
                    
                                           }
                
                
                
            }) { (error) in
                print("error:-",error)
                
            }
        }
    @objc func subscribeAction(_ sender: UIButton)
    {
        print("Subscribe")
        UnsubscribeAPI()
        //        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "UnSubScribePostView") as! UnSubScribePostView
        //               //homevc.objectDict =  object
        //               self.navigationController?.pushViewController(homevc, animated: true)
    }
    @objc func logoutButton(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "", message: "Are you sure you want to log out?".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (suceess) in
            
            
            self.getlogoutAPI()
            
            
        }))
        // alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No".localized(), style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    func UnsubscribeAPI()
    {
        let uid = UserDefaults.standard.object(forKey: "uid") as? Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as? Int
        
        
        
        var params = [Any]()
        
        //parther_ID!,id!,"like"
        //[[],"\(txtEmailId.text!)","test"]
        params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","utm.campaign","get_unsubscribe_campaign",[[],parther_ID!]] as [Any]
        
        
        
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            DispatchQueue.main.async {
                if let j = ObejcData as? [String:Any]{
                    if let data = j["data"]{
                        //print("data:-",data)
                        let dataDict = data as! [NSDictionary]
                        //print("DataDict:-",self.DataDict)
                        
                        
                    }
                }
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
    }
    func getlogoutAPI()  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","set_logout_app",[[parther_ID],"\(DevcieToken!)"]] as [Any]
        let strUrl = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            
            
            
            DispatchQueue.main.async {
                
                let obj = ObejcData as? Bool
                if obj == true
                {
                    UserDefaults.standard.removeObject(forKey: "VerifyOTP")
                    UserDefaults.standard.removeObject(forKey: "parther_ID")
                    UserDefaults.standard.removeObject(forKey: "ProfileData")
                    
                    let homevc = UIStoryboard(name: StoryboardId.MAIN, bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    //homevc.objectDict =  object
                    self.navigationController?.pushViewController(homevc, animated: false)
                }
                else
                {
                    
                }
                
            }
            
            //
            //
            //            if let j = ObejcData as? [String:Any]{
            //                if let data = j["data"] as? NSArray
            //                {
            //                    if (data as AnyObject).count == 0
            //                    {
            //                        // fail
            //                        DispatchQueue.main.async {
            //                            self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter valid email", completionBlock: nil)
            //
            //                        }
            //                    }
            //                    else
            //                    {
            //                        DispatchQueue.main.async {
            //                            UserDefaults.standard.set(data, forKey: "ProfileData")
            //                            UserDefaults.standard.synchronize()
            //
            //                            let object = data[0] as? NSDictionary
            //                            let parther_ID = object?.object(forKey: "id") as! Int
            //                            UserDefaults.standard.set(parther_ID, forKey: "parther_ID")
            //                            UserDefaults.standard.synchronize()
            //                            let homevc = UIStoryboard(name: StoryboardId.MAIN, bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
            //                            homevc.emailStr = "\(self.txtEmailId.text!)"
            //                            self.navigationController?.pushViewController(homevc, animated: true)
            //                        }
            //
            //
            //
            //                    }
            //                }
            //
            //
            //            }
            
            
            
            
        }) { (error) in
            print("error:-",error)
        }
        
        
    }
    
}
//MARK:- For Multiple Images

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    
    
    
    // Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
        }
        //colMedia.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
