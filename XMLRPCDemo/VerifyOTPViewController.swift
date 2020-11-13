//
//  VerifyOTPViewController.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 01/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
//import SwiftyCodeView
import SVPinView
class VerifyOTPViewController: UIViewController {
    var Lnagstr = ""
    @IBOutlet weak var lblVerifyOTP: UILabel!
     @IBOutlet weak var btnResend: UIButton!
     @IBOutlet weak var btnverify: UIButton!
    @IBOutlet weak var lblName: UILabel!
    private var code: String?
    @IBOutlet weak var objView: SVPinView!
    var emailStr = String()
    
    //@IBOutlet weak var VerifyButton: SVPinView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Verify otp".localized()
        
        lblVerifyOTP.text = "Verify otp".localized()
        lblVerifyOTP.numberOfLines = 0
        lblVerifyOTP.sizeToFit()
        
        btnverify.setTitle("VERIFY".localized(), for: .normal)
        btnResend.setTitle("RESEND".localized(), for: .normal)
     
        lblName.text = "Email with your password was sent to your mailbox".localized()
        
        lblName.numberOfLines = 0
        lblName.sizeToFit()
        Lnagstr = Locale.current.languageCode!
        
        objView.borderLineColor = UIColor.black
        objView.activeBorderLineColor = UIColor.blue//UIColor(red: 12, green: 34, blue: 56, alpha: 1.00)//UIColor.green
        objView.borderLineThickness = 1
        objView.activeBorderLineThickness = 3
        
        objView.didFinishCallback = { [weak self] pin in
            print("The pin entered is \(pin)")
            self?.code = "\(pin)"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ResendAction(_ sender: Any) {
        getloginData()
    }
    
    @IBAction func VerifyAction(_ sender: Any)
    {
        if code == nil
        {
            //Alert
            self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter OTP".localized(), completionBlock: nil)
            
        }
        else
        {
            VerifyApi()
        }
    }
    //MARK: API Call
    
    func getloginData()  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_from_email",[[],"\(emailStr)","\(DevcieToken!)","\(Lnagstr)"]] as [Any]
        let strUrl = "\(WebAPI.BaseURL)" + "object"
   
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
           
            
            
            if let obj = ObejcData as? Int
            {
                if obj == 0
                {
                    // Alert
                    DispatchQueue.main.async {
                        self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter valid email".localized(), completionBlock: nil)
                    }
                }
                else
                {
                    
                    UserDefaults.standard.set(ObejcData, forKey: "parther_ID")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                        
                        self.showAlertWithCompletion(pTitle: "", pStrMessage: "OTP is sent to Your Email address..".localized(), completionBlock: nil)
                        
                        
                    }
                }
            }
            
            
            
            
        }) { (error) in
            print("error:-",error)
        }
        
        
    }
    func VerifyApi()  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        // let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_otp_verify",[[],"\(emailStr)","\(self.code!)"]] as [Any]
        let strUrl = "\(WebAPI.BaseURL)" + "object"
       
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            
            let obj = ObejcData as? Bool
            
            if obj == true
            {
                
                UserDefaults.standard.set(true, forKey: "VerifyOTP")
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async {
                    
                    
                    
                    //                            let homevc = UIStoryboard(name: StoryboardId.MAIN, bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
                    //                            self.navigationController?.pushViewController(homevc, animated: true)
                    //
                    let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(homevc, animated: true)
                }
            }
            else
            {
                // Alert
                DispatchQueue.main.async {
                    self.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Enter valid OTP".localized(), completionBlock: nil)
                }
            }
            
            
            
            
            
            
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
