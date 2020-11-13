//
//  CampagionVC.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 01/10/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
//import Alamofire

class CampagionVC: UIViewController {
  var objectDict  = NSDictionary()
    @IBOutlet var tblCampagin : UITableView!
     var DataDict = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Campaign".localized()
        GetCampagindetailsAPI()
        // Do any additional setup after loading the view.
    }
    
    func GetCampagindetailsAPI()
    {
        let uid = UserDefaults.standard.object(forKey: "uid") as? Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as? Int
        
        
        
        var params = [Any]()
        let utm_campaign_id = objectDict.object(forKey: "utm_campaign_id") as? Int
       // let id = object.object(forKey: "id") as? Int
                   //parther_ID!,id!,"like"
                   //[[],"\(txtEmailId.text!)","test"]
                   params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","utm.campaign","get_campaign_details",[[utm_campaign_id!],parther_ID!]] as [Any]
       
        
        
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
           
            DispatchQueue.main.async {
                
                if let j = ObejcData as? [String:Any]{
                    if let data = j["data"]{
                        //print("data:-",data)
                        self.DataDict = data as! [NSDictionary]
                        //print("DataDict:-",self.DataDict)
                        DispatchQueue.main.async {
                            self.tblCampagin.reloadData()
                        }
                        
                    }
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
extension CampagionVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
       }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataDict.count == 0
        {
            return 0
        }
        return DataDict.count + 1
       }
    @objc func btnresponsibleClick(_ sender: UIButton)
        {
           print("RatingViewClick",sender.tag)
        let object = DataDict[sender.tag] as! NSDictionary
            let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                          homevc.partner_idINt = object.object(forKey: "responsible_partner_id") as! Int
                           homevc.ProfileFlag = "1"
                          self.navigationController?.pushViewController(homevc, animated: true)
            
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
           // let cell = tableView.dequeueReusableCell(withIdentifier: "CampaginCell") as! CampaginCell

            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CampaginCell") as! CampaginCell
                 let object = DataDict[indexPath.row] as! NSDictionary
                cell.btnresponsible.tag = indexPath.row
                cell.btnresponsible.addTarget(self, action: #selector(self.btnresponsibleClick), for: .touchUpInside)
                cell.configureCellWith(viewController: self, indexPath1: indexPath, object: object)

                 cell.lblname.text = "\(objectDict.object(forKey: "name") ?? "")"
                 cell.lblname.text = "\(objectDict["name"] ?? "")"
                let datestr = "\(objectDict.object(forKey: "date") as! String) "
                         let isoDate = "\(datestr)"

                         let dateFormatter = DateFormatter()
                       //  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                         dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

                         let date = dateFormatter.date(from:isoDate)!
                        
                         //dateDD.MM HH:MM
                         let timeAgo:String = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
                        
                
                
                cell.lbldate.text = "Published by ".localized() + "\(objectDict["post_owner"] ?? "") " + "\(timeAgo) "
                cell.lbldate.numberOfLines = 0
                cell.lbldate.sizeToFit()
                
                            
                             // let fileUrl = URL(string: "\(object["image"] ?? "")")
                              let imgesUrl = objectDict["image"] as? String
                                                            let IMagesURl = imgesUrl!.removeWhitespace()
                                             let fileUrl = URL(string: IMagesURl)
                             cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))

//                              lazyDownloadImage(from:fileUrl!) { (Error, Image) in
//                                  cell.imgUser.image = Image
//                              }

                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CampaginratinCell") as! CampaginratinCell
               // let object = DataDict[indexPath.row] as! NSDictionary
                cell.configureCellWith(viewController: self, indexPath1: indexPath, object: objectDict)
                 return cell
            }
            
           
                                   
          
        }
    
   
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())

        if (components.year! >= 2) {
            return "\(components.year!) " + "years ago".localized()
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) " + "week ago".localized()
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 " + "week ago".localized()
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) " + "hour ago".localized()
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 " + "hour ago".localized()
            } else {
                return "An hour"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) " + "min ago".localized()
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 " + "min ago".localized()
            } else {
                return "A min"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec"
        } else {
            return "now ago".localized()
        }

    }
   /* func lazyDownloadImage(from url: URL, completion: (( _ error: Error?,  _ result: UIImage?) -> ())? = nil) {
        let request = Alamofire.request(url, method: .get).validate().responseData { [weak self] (response) in
            
            //self?.progressControl.lazyImageRequests[url] = nil
            
            guard let data = response.data else {
                completion?(response.error, nil)
                return
            }
            
            completion?(response.error, UIImage(data: data))
        }
        
    } */
}
