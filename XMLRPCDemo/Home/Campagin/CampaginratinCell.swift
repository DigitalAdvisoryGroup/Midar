//
//  CampaginratinCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 01/10/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Cosmos
class CampaginratinCell: UITableViewCell {
    @IBOutlet weak var viewRating: CosmosView!
     var strrating = 0
     var objectDict  = NSDictionary()
     @IBOutlet weak var lblHowWase: UILabel!
     @IBOutlet weak var txtdesc: UITextField!
     @IBOutlet weak var btnSubmit: UIButton!
    var viewController = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        lblHowWase.text = "How was your experience?".localized()
        btnSubmit.setTitle("Submit".localized(), for: .normal)
        txtdesc.textAlignment = .left
               txtdesc.contentVerticalAlignment = .top
               viewRating.rating = 0
                viewRating.settings.fillMode = .half
               viewRating.didFinishTouchingCosmos = { rating in
                   print("ratingIs:-",rating)
                   self.strrating = Int(rating)
               }

        // Initialization code
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,object : NSDictionary)
    {
        objectDict = object
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

        func RatingAPI()  {
            self.viewController.view.frame.origin.y = 0
            self.viewController.view.endEditing(true)
            //Json
            let uid = UserDefaults.standard.object(forKey: "uid")
            let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
            let PostId =  objectDict.object(forKey: "id") as! Int
            
            let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"comment":"\(txtdesc.text!)","record_type":"rating","rating":strrating]
            let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
            
            print("params:-",params)
            let url = "\(WebAPI.BaseURL)" + "object"
            
            
            KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.viewController.view, success: { (ObejcData) in
                print("ObejcData:-",ObejcData)
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                   // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                   //  self.navigationController?.popViewController(animated: true)
    //                self.showAlertWithCompletion(pTitle: "", pStrMessage: "Comment added successfully") { (value) in
    //
    //                }
                }
                
            }) { (error) in
                print("error:-",error)
            }
            
            
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
