//
//  LoginVC.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit

import wpxmlrpc


enum UIUserInterfaceIdiom : Int {
    case unspecified

    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}

class LoginVC: UIViewController {
    @IBOutlet weak var txtEmailId: UITextField!
//      @IBOutlet weak var BtnTerm: CheckBox!
    @IBOutlet weak var HeightConsttxtEmail: NSLayoutConstraint!
    //
     @IBOutlet weak var btnPrivacy: UIButton!
     @IBOutlet weak var btnMidarTerm: UIButton!
    @IBOutlet weak var lblthe: UILabel!
      @IBOutlet weak var lblBylogin: UILabel!
     @IBOutlet weak var lblTerm: UILabel!
     @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnTerm: UIButton!
    //    @IBOutlet weak var btn_box: UIButton!
    var Lnagstr = ""
    override func viewDidLoad() {
        super.viewDidLoad()

       // [txtEmailId].forEach { ($0?.delegate = self)! }
      //  lblBylogin.text = "By Logging in, you agree".localized()
        lblthe.text = "I agree to the".localized()
        //btnMidarTerm.setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, for: <#T##UIControl.State#>)
        lblTerm.text = "Terms of Service and Privacy Policy".localized()
        lblTerm.numberOfLines = 0
        lblTerm.sizeToFit()
        
      //  btnPrivacy.setTitle("and Privacy Policy".localized(), for: .normal)
        txtEmailId.placeholder = "Enter Your Email".localized()
        lblName.text = "Die Transformationsinitiative des BIT".localized()
       // lblTerm.text = "Accept Terms".localized()
        lblName.numberOfLines = 0
        lblName.sizeToFit()
        btnLogin.setTitle("Login".localized(), for: .normal)
        
        
        //ic_check_box_outline_blank
        //ic_check_box
       btnTerm.setImage(UIImage.init(named: "Squre_UnFill"), for: .normal)
      btnTerm.setImage(UIImage.init(named: "Squre_Fill"), for: .selected)
       btnTerm.addTarget(self, action: #selector(self.toggleCheckboxSelection), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
    }
   
    @objc func toggleCheckboxSelection() {
        btnTerm.isSelected = !btnTerm.isSelected
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        Lnagstr = Locale.current.languageCode!
         getUserId()
        
    }
  
  
    
    
    @IBAction func InfoAction(_ sender: Any)
    {
       let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ImprintVC") as! ImprintVC
                  //homevc.objectDict =  object
                  self.navigationController?.pushViewController(homevc, animated: true)
//        if let url = URL(string: "https://midar.odoo.com/app-impressum") {
//            UIApplication.shared.open(url)
//        }
    }
    
    @IBAction func ActionTermCondition(_ sender: Any)
    {
        if let url = URL(string: "https://www.midar.swiss/app-netiquette") {
                   UIApplication.shared.open(url)
               }
    }
    
    @IBAction func ActionLogin(_ sender: Any)
    {
        
        if (txtEmailId.text?.isEmpty)!{
            self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter Email".localized(), completionBlock: nil)
        }else if !(txtEmailId.text?.isValidEmail)!{
            //   self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter Valid Email", completionBlock: nil)
            showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter Valid Email".localized(), completionBlock: nil)
        }
            
        else if btnTerm.isSelected == false {
            showAlertWithCompletion(pTitle: "", pStrMessage: "Please indicate that you have read and agree to the Terms and Conditions and Privacy Policy".localized(), completionBlock: nil)

        }
        else
        {
            getloginData()
        }
        
    }
    //MARK:- API Calling
    func getUserId()  {
        
        
        let params = ["\(WebAPI.DBName)","\(WebAPI.UserName)", "\(WebAPI.Password)"] as [Any]
        let strUrl = "\(WebAPI.BaseURL)" + "common"
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "login", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
           
            UserDefaults.standard.set(ObejcData, forKey: "uid")
            UserDefaults.standard.synchronize()
            
        }) { (error) in
            print("error:-",error)
        }
        
        
        
        
    }
    
    func getloginData()  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_from_email",[[],"\(txtEmailId.text!)","\(DevcieToken!)","\(Lnagstr)","ios"]] as [Any]
        let strUrl = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            
            
            if let j = ObejcData as? [String:Any]{
                if let data = j["data"] as? NSArray
                {
                    if (data as AnyObject).count == 0
                    {
                        // fail
                        DispatchQueue.main.async {
                            self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter Valid Email".localized(), completionBlock: nil)
                            
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(data, forKey: "ProfileData")
                            UserDefaults.standard.synchronize()
                            
                            let object = data[0] as? NSDictionary
                            let parther_ID = object?.object(forKey: "id") as! Int
                            UserDefaults.standard.set(parther_ID, forKey: "parther_ID")
                            UserDefaults.standard.synchronize()
                            let homevc = UIStoryboard(name: StoryboardId.MAIN, bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
                            homevc.emailStr = "\(self.txtEmailId.text!)"
                            self.navigationController?.pushViewController(homevc, animated: true)
                        }
                        
                        
                        
                    }
                }
                
               
            }
            
            
            
            
        }) { (error) in
            print("error:-",error)
        }
        
        
    }
    /* func getdata() */
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
