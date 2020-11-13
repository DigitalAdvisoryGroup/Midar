//
//  OtherProfileVC.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 02/10/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit

class OtherProfileVC: UIViewController {
 var DataDict = [NSDictionary]()
    var objectDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("objectDict:-",objectDict)
        getDataAPi()
        // Do any additional setup after loading the view.
    }

            func getDataAPi()  {
                let uid = UserDefaults.standard.object(forKey: "uid")
               let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
               // let parther_ID = UserDefaults.standard.object(forKey: "parther_ID")
                let partnerid = objectDict.object(forKey: "partner_id") as! Int
    //"name","email","street","street2","mobile","city","state_id","country_id","zip","image_1920"
                //["name","email","street","street2","mobile","city","state_id","country_id","zip","image_1920"]
                let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_profile_data",[[partnerid]]] as [Any]
                let strUrl = "\(WebAPI.BaseURL)" + "object"
                // var params = ["\(WebAPI.DBName)","admin", "admin"] as [Any]
                
                
                KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                   
                    
                    if let j = ObejcData as? [String:Any]{
                        if let data = j["data"]{
                            //print("data:-",data)
                            self.DataDict = data as! [NSDictionary]
                            //print("DataDict:-",self.DataDict)
                            DispatchQueue.main.async {
                              //  self.tblProfile.reloadData()
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
