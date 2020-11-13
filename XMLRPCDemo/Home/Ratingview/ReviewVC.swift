//
//  ReviewVC.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 17/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Cosmos

class ReviewVC: UIViewController {
    @IBOutlet weak var viewRating: CosmosView!
    var strrating = 0
    var objectDict  = NSDictionary()
   
    @IBOutlet weak var txtdesc: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtdesc.textAlignment = .left
        txtdesc.contentVerticalAlignment = .top
        viewRating.rating = 0
         viewRating.settings.fillMode = .half
        viewRating.didFinishTouchingCosmos = { rating in
            print("ratingIs:-",rating)
            self.strrating = Int(rating)
        }

        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        viewRating.didTouchCosmos = { rating in
            print("didTouchCosmos:-",rating)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Review"
        navigationController?.setNavigationBarHidden(false, animated: true)
        // navigationController?.navigationBar.barTintColor = UIColor.blue
       

    }
    @IBAction func BackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SubmitAction(_ sender: Any)
    {
//        if txtdesc.text == ""
//        {
//            showAlert("Enter your Experiance")
//        }
//        else
//        {
//            //Api
//            RatingApi()
//        }
        
        RatingAPI()
    }
    
    @IBAction func skipAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func RatingAPI()  {
        self.view.frame.origin.y = 0
        view.endEditing(true)
        //Json
        let uid = UserDefaults.standard.object(forKey: "uid")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        let PostId =  objectDict.object(forKey: "id") as! Int
        
        let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"comment":"\(txtdesc.text!)","record_type":"rating","rating":strrating]
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            DispatchQueue.main.async {
                 self.navigationController?.popViewController(animated: true)
//                self.showAlertWithCompletion(pTitle: "", pStrMessage: "Comment added successfully") { (value) in
//
//                }
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
extension ReviewVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
