//
//  ProfileCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 05/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
//import Alamofire
import Kingfisher
class ProfileCell: UITableViewCell {
    @IBOutlet var lblVersion : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblphone : UILabel!
         @IBOutlet var btnLan : UIButton!
     @IBOutlet var btnUserProfile : UIButton!
         @IBOutlet var imgUser : UIImageView!
          @IBOutlet var lbladdress : UILabel!
         @IBOutlet var btnLogout : UIButton!
    @IBOutlet var btnSubscribe : UIButton!
    @IBOutlet var btnChnageConnection : UIButton!
    var viewController = UIViewController()
     
    override func awakeFromNib() {
        super.awakeFromNib()
        btnLogout.setTitle("Disconnect from Midar".localized(), for: .normal)
        btnChnageConnection.setTitle("Change Connection".localized(), for: .normal)
        // Initialization code
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,object : NSDictionary)
    {
        self.viewController = viewController
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let changeconnection = object.object(forKey: "change_connection") as! Int
        if changeconnection == 0
        {
            btnChnageConnection.isHidden = true
        }
        else
        {
             btnChnageConnection.isHidden = false
        }
        
        
        
        lblVersion.text = "\(appVersion ?? "")"
        lblVersion.numberOfLines = 0
        lblVersion.sizeToFit()
        lblName.text = "\(object.object(forKey: "name") ?? "")"
         lblEmail.text = "\(object.object(forKey: "email") ?? "")"
        lblphone.text = "\(object.object(forKey: "mobile") ?? "")"
      //  let strCode = Locale.current.languageCode!

        let lancode = "\(object.object(forKey: "lang") ?? "")"

        let strLang = Locale.current.localizedString(forLanguageCode: lancode)!
        btnLan.setTitle(strLang, for: .normal)
       // street street2  city    zip  state_id Array 2 //  country_id arrat
        let state_idary = object.object(forKey: "state_id") ?? ""//as! NSArray
        let country_idary = object.object(forKey: "country_id") ?? "" //as! NSArray
        
        let straddres = "\(object.object(forKey: "street") ?? ""), " + "\(object.object(forKey: "street2") ?? ""), " + "\(object.object(forKey: "city") ?? ""), " + "\(object.object(forKey: "zip") ?? ""), " + "\(state_idary), " + "\(country_idary)"
        
        lbladdress.text = "\(straddres)"
        lbladdress.numberOfLines = 0
        lbladdress.sizeToFit()
       
        
       let imgesUrl = object.object(forKey: "image_1920") as? String
                       let IMagesURl = imgesUrl!.removeWhitespace()
        let fileUrl = URL(string: IMagesURl)
       // let fileUrl = URL(string: "\(object.object(forKey: "image_1920") ?? "")")
        self.imgUser.kf.setImage(with: URL.init(string: IMagesURl))

//        lazyDownloadImage(from:fileUrl!) { (Error, Image) in
//            self.imgUser.image = Image
////            let OrientationImg = self.fixOrientation(img: Image!)
////             self.imgUser.image = OrientationImg
//        } 
 
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
        //        if progressControl.lazyImageRequests == nil {
        //            progressControl.lazyImageRequests = [url: request]
        //        } else {
        //            progressControl.lazyImageRequests![url] = request
        //        }
    } */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnImagesProfileAction(_ sender: Any)
    {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "From Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            let vc = UIImagePickerController()
                          vc.sourceType = .photoLibrary
                          vc.modalPresentationStyle = .fullScreen
                          vc.delegate = self
                         // self.present(vc, animated: true)
            UIApplication.topViewController()?.present(vc, animated: true) {
                            //print("completion block")
                      }
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            let vc = UIImagePickerController()
                           vc.sourceType = .camera
                           vc.modalPresentationStyle = .fullScreen
                           vc.delegate = self
                           //self.present(vc, animated: true)
            UIApplication.topViewController()?.present(vc, animated: true) {
                  //print("completion block")
            }
        }))

//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
//            print("User click Delete button")
//        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
//        alert.popoverPresentationController?.sourceView = self.viewController.view
//        alert.popoverPresentationController?.sourceRect = self.viewController.view.bounds
       if let popoverController = alert.popoverPresentationController {
          popoverController.sourceView =  self.viewController.view
          popoverController.sourceRect = CGRect(x:  self.viewController.view.bounds.midX, y:  self.viewController.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }
        UIApplication.topViewController()?.present(alert, animated: true) {
              print("completion block")
        }
        
    }
}
extension ProfileCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    
    
    
    // Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imgUser.image = image
        }
        ImagesUploadedAPI()
        //colMedia.reloadData()
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
       // self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       UIApplication.topViewController()?.dismiss(animated: true, completion: nil)

       // self.dismiss(animated: true, completion: nil)
    }
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }
   
    func ImagesUploadedAPI()  {
                let uid = UserDefaults.standard.object(forKey: "uid")
                let parther_ID = UserDefaults.standard.object(forKey: "parther_ID")
        
        
        
        let OrientationImg = fixOrientation(img: imgUser.image!)
        
        let image : UIImage = OrientationImg//imgUser.image!
        //Now use image to create into NSData format
        let imageData:NSData = image.pngData()! as NSData
        let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)

        
        let jsonreuest: [String: Any] = ["image_1920": "\(strBase64)"]

    //"name","email","street","street2","mobile","city","state_id","country_id","zip","image_1920"
                let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","write",[[parther_ID],jsonreuest]] as [Any]
                let strUrl = "\(WebAPI.BaseURL)" + "object"
                // var params = ["\(WebAPI.DBName)","admin", "admin"] as [Any]
                
                
                KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.viewController.view, success: { (ObejcData) in
                   
                   //  self.DataDict = ObejcData as! [NSDictionary]
                    DispatchQueue.main.async {
                       // self.tblProfile.reloadData()
                                           }
                    
                    
                    
                    
                }) { (error) in
                    print("error:-",error)
                }
                
                
            }
}
