//
//  ReplayCommentVC.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 29/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import GrowingTextView
//import Alamofire
import SKPhotoBrowser
class ReplayCommentVC: UIViewController,GrowingTextViewDelegate,UITextFieldDelegate,UIDocumentPickerDelegate {
    @IBOutlet var tblCommentPost : UITableView!
    @IBOutlet weak var lblName: UILabel!
     @IBOutlet weak var PostView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    var objectDict  = NSDictionary()
    var CommentAry = [NSDictionary]()
    var categoryId = 0
    var PostId = 0
    
     var DataDictProfie = [NSDictionary]()
     @IBOutlet var btnUploaded : UIButton!
     var strSelectOptionImages = 0
    @IBOutlet weak var lblFileName: UILabel!
       @IBOutlet weak var ViewImages: UIView!
       @IBOutlet weak var viewHeightFileName: NSLayoutConstraint!
     var upload_limit = 0
    var base64 = String()
       var fileName = String()
       var ImagesSize = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPost.isUserInteractionEnabled = false
        btnPost.setTitleColor(UIColor.lightGray, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
              view.addGestureRecognizer(tapGesture)
        SetTextData()
         GetPostRlyDetails(CommentId: categoryId)
        // Do any additional setup after loading the view.
    }
    func SetTextData() {
        textView.placeholder = "Leave your thoughts here..".localized()
         btnPost.setTitle("post".localized(), for: .normal)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
           self.view.frame.origin.y = 0 // Move view to original position
       }
       @objc private func keyboardWillChangeFrame(_ notification: Notification) {
           if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
               if #available(iOS 11, *) {
                   if keyboardHeight > 0 {
                       keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                   }
               }
               //textViewBottomConstraint.constant = keyboardHeight + 8
               self.view.frame.origin.y =  -keyboardHeight //+ 8
               view.layoutIfNeeded()
           }
       }
       @objc func tapGestureHandler() {
           view.endEditing(true)
       }
       deinit {
           NotificationCenter.default.removeObserver(self)
       }
       

       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        self.title = "Comments".localized()
       
           navigationController?.setNavigationBarHidden(false, animated: true)
           // navigationController?.navigationBar.barTintColor = UIColor.blue
           print("Comment:-",objectDict)
          print("CommentAry:-",CommentAry)
      //  CommentAry.removeAll()
       // var CommnentID  = (CommentAry[0].object(forKey: "id") as? Int)!
       
 
        if ImagesSize == 1
        {
            //alert
            
            ViewImages.isHidden = true
            viewHeightFileName.constant = 0
            fileName = ""
            base64 = ""
            ImagesSize = 0
            btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
            let strmsg = "Maximum images size " + "\(upload_limit)" + "MB uploaded"
            self.showAlertWithCompletion(pTitle: "", pStrMessage: "\(strmsg ?? "")", completionBlock: nil)
        }
        
           self.DataDictProfie = UserDefaults.standard.object(forKey: "ProfileData") as! [NSDictionary]
                 let object1 = DataDictProfie[0]
            let imgesUrl = object1["image_1920"] as? String
               let IMagesURl = imgesUrl!.removeWhitespace()
          if IMagesURl == ""
          {
           
           }else
          {
           self.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
//           lazyDownloadImage(from:URL.init(string: IMagesURl)!) { (Error, Image) in
//                       self.imgUser.image = Image
//                   }

           }



       }
       

       func GetPostRlyDetails(CommentId: Int) {
           let uid = UserDefaults.standard.object(forKey: "uid") as! Int
           let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
           //  UserDefaults.standard.set(ObejcData, forKey: "")
           
           let params = ["\(WebAPI.DBName)",uid, "\(WebAPI.Password)","social.bit.comments","get_reply_for_comment",[[CommentId]]] as [Any]
           let url = "\(WebAPI.BaseURL)" + "object"
           KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
               if let j = ObejcData as? [String:Any]{
                   if let data = j["data"] as? NSArray{
                       //print("data:-",data)
                       self.objectDict = data[0] as! NSDictionary
                       // self.upload_limit = 5
                       self.upload_limit = (self.objectDict.object(forKey: "upload_limit") as? Int)!
                       self.CommentAry = data as! [NSDictionary]
                       //self.DataDict = data as! [NSDictionary]
                       //print("DataDict:-",self.DataDict)
                       DispatchQueue.main.async {
                           self.tblCommentPost.reloadData()
                       }
                       
                   }
               }
               
               
           }) { (error) in
               print("error:-",error)
               
           }
       }

       //MARK: UiTextFiled Method
       
       
       func textViewDidChange(_ textView: UITextView) {
           print("textViewDidChange:- ",textView.text)
           if textView.text == ""
           {
               btnPost.isUserInteractionEnabled = false
               btnPost.setTitleColor(UIColor.lightGray, for: .normal)
               
           }
           else
           {
               btnPost.isUserInteractionEnabled = true
               btnPost.setTitleColor(UIColor.systemBlue, for: .normal)
               
           }
       }
       func textViewDidEndEditing(_ textView: UITextView) {
           print("textViewDidEndEditing:- ",textView.text)
           if textView.text == ""
           {
               btnPost.isUserInteractionEnabled = false
               btnPost.setTitleColor(UIColor.lightGray, for: .normal)
               
           }
           else
           {
               btnPost.isUserInteractionEnabled = true
               btnPost.setTitleColor(UIColor.systemBlue, for: .normal)
               
           }
       }

     @IBAction func ActionCloseImages(_ sender: Any)
     {
         ViewImages.isHidden = true
                           viewHeightFileName.constant = 0
         fileName = ""
                   base64 = ""
                   ImagesSize = 0
                   btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
     }
     func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
         print("DocumentUrl:-",urls)
        // documentUrl = urls[0]//url[0]
         print("documentUrlStr:-",urls)
         print(urls[0].lastPathComponent)
    //  let tempMedia : MediaTypes = MediaTypes.init(smId: "", type: .document,document:urls[0] )
      // self.attachMedia.append(tempMedia)
         lblFileName.text = urls[0].lastPathComponent
         fileName = "\(lblFileName.text!)"
         var Size = Float()
         let data = NSData(contentsOf: urls[0])
         
         //let imageData:NSData = image.pngData()! as NSData
         let strBase64:String = data!.base64EncodedString(options: .lineLength64Characters)
                  
         Size = Float(Double(data!.count)/1024/1024)
                  if Int(Size) <= upload_limit
                      {
                          print("ImagesSize:-",Size)
                          //ImagesSize = 0
                           base64 = strBase64
                          ViewImages.isHidden = false
                          viewHeightFileName.constant = 50
                          // Here your image
                      }
                  else
                      {
                         
                         ViewImages.isHidden = true
                                   viewHeightFileName.constant = 0
                                   fileName = ""
                                   base64 = ""
                                   ImagesSize = 0
                                   btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
                                   let strmsg = "Maximum images size " + "\(upload_limit)" + "MB uploaded"
                                   self.showAlertWithCompletion(pTitle: "", pStrMessage: "\(strmsg ?? "")", completionBlock: nil)
                        

                  }
         
     }
           //MARK: Button Action
           @IBAction func btnImagesProfileAction(_ sender: Any)
               {
                   let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)

                   alert.addAction(UIAlertAction(title: "Photo", style: .default , handler:{ (UIAlertAction)in
                       print("User click Approve button")
                       
                       self.OpenImagesSlectedSheet()
      
                   }))

                   alert.addAction(UIAlertAction(title: "Document", style: .default , handler:{ (UIAlertAction)in
                       print("User click Edit button")
       //
       //                }
                       
                       let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data","ppt"], in: .import)
                              //let documentPicker = UIDocumentPickerViewController(documentTypes: ["ppt"], in: .import)
                              documentPicker.delegate = self
                              documentPicker.modalPresentationStyle = .popover
                            if let popoverController = documentPicker.popoverPresentationController {
                              popoverController.sourceView =  self.view
                              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y:  self.view.bounds.midY, width: 0, height: 0)
                              popoverController.permittedArrowDirections = []
                            }
                    
                              self.present(documentPicker, animated: true, completion: nil)
                   }))

           

                   alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                       print("User click Dismiss button")
                   }))

        
           if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView =  self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y:  self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                  }
                   UIApplication.topViewController()?.present(alert, animated: true) {
                         print("completion block")
                   }
                   
               }
    
    func  OpenImagesSlectedSheet()  {
            let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "From Gallery", style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.strSelectOptionImages = 0
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
                self.strSelectOptionImages = 1
                let vc = UIImagePickerController()
                               vc.sourceType = .camera
                //vc.allowsEditing = true
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

    
    if let popoverController = alert.popoverPresentationController {
             popoverController.sourceView =  self.view
             popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y:  self.view.bounds.midY, width: 0, height: 0)
             popoverController.permittedArrowDirections = []
           }
            UIApplication.topViewController()?.present(alert, animated: true) {
                  print("completion block")
            }
            
        }
    @IBAction func PostAction(_ sender: Any)
        {
            self.view.frame.origin.y = 0
            view.endEditing(true)
             let object = CommentAry[0] as! NSDictionary
            //Json
            let uid = UserDefaults.standard.object(forKey: "uid")
            let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
           // let PostId =  objectDict.object(forKey: "id") as! Int
            let parent_id =  object.object(forKey: "id") as! Int

            let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"comment":"\(textView.text!)","parent_id":parent_id,"record_type":"comment","filename":"\(fileName)","content":"\(base64)"]
            let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
            
           // print("params:-",params)
            let url = "\(WebAPI.BaseURL)" + "object"
            
            
            KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                print("ObejcData:-",ObejcData)
                DispatchQueue.main.async {
                     
                    self.fileName = ""
                                   self.base64 = ""
                                   self.textView.text = ""
                                   self.ViewImages.isHidden = true
                                   self.viewHeightFileName.constant = 0
                                          
                                                    self.ImagesSize = 0
                                                    self.btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
                    self.navigationController?.popViewController(animated: true)
    //                self.showAlertWithCompletion(pTitle: "", pStrMessage: "Comment added successfully") { (value) in
    //
    //                }
                }
                
            }) { (error) in
                print("error:-",error)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ReplayCommentVC: UITableViewDataSource,UITableViewDelegate
{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentAry.count
    }
    
    @objc func handleCommentUserImages(_ sender: UITapGestureRecognizer? = nil) {
                   // handling code
                  
           let tag = sender?.view?.tag
           print("handleCommentUserImages:-",tag)
           let  object = CommentAry[tag!] as! NSDictionary
            let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                  homevc.partner_idINt = object.object(forKey: "partner_id") as! Int
                   homevc.ProfileFlag = "1"
        
        UIApplication.topViewController()?.show(homevc, sender: nil)
                  //self.navigationController?.pushViewController(homevc, animated: true)
       }
    
    @objc func handleCommentCommentname(_ sender: UITapGestureRecognizer? = nil) {
                      // handling code
                     
              let tag = sender?.view?.tag
              print("handleCommentUserImages:-",tag)
              let  object = CommentAry[tag!] as! NSDictionary
               let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                     homevc.partner_idINt = object.object(forKey: "partner_id") as! Int
                      homevc.ProfileFlag = "1"
           
           UIApplication.topViewController()?.show(homevc, sender: nil)
                     //self.navigationController?.pushViewController(homevc, animated: true)
          }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListReplayCell") as! CommentListReplayCell
       // cell.contentView.bounds = tableView.bounds
       // cell.updateConstraints()
         //      cell.layoutIfNeeded()
        let object = CommentAry[indexPath.row] as! NSDictionary
        cell.objectDict = objectDict
        let name = object.object(forKey: "author_name") as! String
        

        lblName.text = "Replies to ".localized() + "\(name)" + " comment on this post".localized()
        cell.configureCellWith(viewController: self, indexPath1: indexPath, object: object)
        cell.DeleteDropDown.selectionAction = { [weak self] (index, item) in
            
            print("DeletedCOmmentAPi",cell.DeleteDropDown.tag)
            //print("index:-",index)
            //print("self?.CommentAry:-",self?.CommentAry)
            let dataDict = self?.CommentAry[indexPath.row] as! NSDictionary
            let id = dataDict.object(forKey: "id") as! Int
            print("Comment ID:-",id)
            self?.CommentAry.remove(at: indexPath.row)
            self?.DeleteCommentAPI(CommentID: id)
            //APi
        }
        

        cell.btnLikeCallBack = {(indexPath, value) in
            //Api Calling
            
            self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object)
            //self.tblSocialPost.reloadRows(at: [indexPath], with: .fade)
            
        }
        cell.btnDisLikeCallBack = {(indexPath, value) in
            //Api Calling
            
            self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object)
            //self.tblSocialPost.reloadRows(at: [indexPath], with: .fade)
            
        }
        
        var media_idsAry = [NSDictionary]()
        media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
        
        
        if media_idsAry.count == 0
        {
            // 0 size
            cell.cnImagesViewHeight.constant = 0
             cell.ViewPDF.isHidden = true
        }
        else
        {
              let dict = media_idsAry[0] as? NSDictionary
            cell.cnImagesViewHeight.constant = 128
                        let type = dict!.object(forKey: "mimetype") as? String
                       
          
           if type == "pdf"
           {
            cell.ViewPDF.isHidden = false
            let imgesUrl = dict!.object(forKey: "url") as? String
            let IMagesURl = imgesUrl!.removeWhitespace()

            let theURL = URL(string: IMagesURl)  //use your URL
            let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
            cell.lblPdfName.text = "\(fileNameWithExt ?? "")"
            cell.lblPdfName.numberOfLines =  0
            cell.lblPdfName.sizeToFit()
            cell.ViewPDF.tag = indexPath.row - 1
                                                let tapImagesCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handlePdfViewOpen))
                                                                    cell.ViewPDF.addGestureRecognizer(tapImagesCommentUser)
                                         cell.ViewPDF.isUserInteractionEnabled = true
            }
            else
           {
            cell.ViewPDF.isHidden = true
            cell.imgCommentUserImages.tag = indexPath.row - 1
                                  let tapImagesCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handleImagesViewOpen))
                                                      cell.imgCommentUserImages.addGestureRecognizer(tapImagesCommentUser)
                           cell.imgCommentUserImages.isUserInteractionEnabled = true
                           
                let imgesUrl = dict!.object(forKey: "url") as? String
                                                 let IMagesURl = imgesUrl!.removeWhitespace()
                                 let fileUrl = URL(string: IMagesURl)
                                  cell.imgCommentUserImages.kf.setImage(with: URL.init(string: IMagesURl))

//                                  lazyDownloadImage(from:fileUrl!) { (Error, Image) in
//                                      cell.imgCommentUserImages.image = Image
//                                  }
            }
           
            
        }
        
        return cell
    }

   // comment Images
   @objc func handlePdfViewOpen(_ sender: UITapGestureRecognizer? = nil) {
                   // handling code
                  
       let tag = sender?.view?.tag
       let  object = CommentAry[0] as! NSDictionary
              var media_idsAry = [NSDictionary]()
                   media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
       let dict = media_idsAry[0] as? NSDictionary
       
       let urlstr = dict!.object(forKey: "url") as? String
     let IMagesURl = urlstr!.removeWhitespace()
       let theURL = URL(string: IMagesURl)  //use your URL
                     
       let playerViewController = webviewClass()
       playerViewController.str = IMagesURl
       // playerViewController.fileURLs = urlNS!
       UIApplication.topViewController()?.show(playerViewController, sender: nil)
   }
    
    @objc func handleImagesViewOpen(_ sender: UITapGestureRecognizer? = nil) {
                  // handling code
                 
          let tag = sender?.view?.tag
       //   print("handleCommentUserImages:-",tag)
          let  object = CommentAry[0] as! NSDictionary
        var media_idsAry = [NSDictionary]()
             media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
              let dict = media_idsAry[0] as? NSDictionary
        var images = [SKPhoto]()
                   SKPhotoBrowserOptions.displayAction = false
                   
                   for i in 0..<media_idsAry.count
                   {
                       let dict = media_idsAry[i] as? NSDictionary
                       let imgesUrl = dict?.object(forKey: "url") as? String
                       let IMagesURl = imgesUrl!.removeWhitespace()
                       let photo = SKPhoto.photoWithImageURL(IMagesURl as! String)
                       photo.shouldCachePhotoURLImage = true
                       images.append(photo)
                       // print("i:-",i)
                   }
                   
                   
                   let browser = SKPhotoBrowser(photos: images)
                   SKPhotoBrowserOptions.displayAction = true
                   //browser.updateCloseButton(#imageLiteral(resourceName: "backArrow"))
                   browser.initializePageIndex(1)
                   UIApplication.topViewController()?.present(browser, animated: true, completion: {})
                   
        
        
        
      }
    @objc func RatingViewClick(_ sender: UIButton)
     {
        print("RatingViewClick",sender.tag)
        //var object = NSDictionary()
               
             //   object = DataDict[sender.tag] as! NSDictionary
               let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
               homevc.objectDict =  objectDict
               self.navigationController?.pushViewController(homevc, animated: true)
    }
    //MARK: API CAlling
    func likeUnlikeApi(Indexpath:IndexPath,value:Int,object : NSDictionary)
    {
       
        
        //////
         let likevalue = object.object(forKey: "comment_like") as? Int
        let uid = UserDefaults.standard.object(forKey: "uid")
                let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
               // let PostId =  objectDict.object(forKey: "id") as! Int
                 let parent_id =  object.object(forKey: "id") as! Int
        let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"parent_id":parent_id,"record_type":"com_like"]
                let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
                
                print("params:-",params)
                let url = "\(WebAPI.BaseURL)" + "object"
                
                
                KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                    print("ObejcData:-",ObejcData)
                    DispatchQueue.main.async {
                       // let object1 = self.DataDict[Indexpath.row]
                       DispatchQueue.main.async {
                           if likevalue == 0
                           {
                               //like
                               object.setValue(1, forKey: "comment_like")
                           }
                           else
                           {
                               //dislike
                               object.setValue(0, forKey: "comment_like")
                               
                           }
                           self.CommentAry[Indexpath.row] = object
                          // self.tblSocialPost.reloadData()
                           // self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                           //  self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                       }
                    }
                    
                }) { (error) in
                    print("error:-",error)
                }
        
    }
    func DislikeUnlikeApi(Indexpath:IndexPath,value:Int,object : NSDictionary)
    {
        
        
        let likevalue = object.object(forKey: "comment_like") as? Int
              let uid = UserDefaults.standard.object(forKey: "uid")
                      let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
                      //let PostId =  objectDict.object(forKey: "id") as! Int
                       let parent_id =  object.object(forKey: "id") as! Int
              let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"parent_id":parent_id,"record_type":"com_dislike"]
                      let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
                      
                      print("params:-",params)
                      let url = "\(WebAPI.BaseURL)" + "object"
                      
                      
                      KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                          print("ObejcData:-",ObejcData)
                          DispatchQueue.main.async {
                             // let object1 = self.DataDict[Indexpath.row]
                             DispatchQueue.main.async {
                                 if likevalue == 0
                                 {
                                     //like
                                     object.setValue(1, forKey: "comment_like")
                                 }
                                 else
                                 {
                                     //dislike
                                     object.setValue(0, forKey: "comment_like")
                                     
                                 }
                                 self.CommentAry[Indexpath.row] = object
                                // self.tblSocialPost.reloadData()
                                 // self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                                 //  self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                             }
                          }
                          
                      }) { (error) in
                          print("error:-",error)
                      }
              
    }
    
    func DeleteCommentAPI(CommentID: Int)  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
      //  let PostId =  objectDict.object(forKey: "id") as! Int
        
        //let jsonreuest: [String: Any] = ["post_id": "\(PostId)","partner_id":"\(parther_ID)","comment":"\(textView.text!)"]
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","unlink",[CommentID]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            
            let data = ObejcData as? Bool
            
            if data == true
            {
                
                DispatchQueue.main.async {
                    
                    self.tblCommentPost.reloadData()
//                    self.showAlertWithCompletion(pTitle: "", pStrMessage: "Comment deleted successfully") { (value) in
//
//                        //  self.navigationController?.popViewController(animated: true)
//                    }
                }
            }
            else
            {
                
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
        
    }
    
}
//MARK: Images Picker Delegate

extension ReplayCommentVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    
    
    
    // Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          var Size = Float()
        
        if strSelectOptionImages == 1
        {
            // camera
            

            if let image = info[.originalImage] as? UIImage {
               // imgUser.image = image
              //  UserImagesSelected = image
                let imagessd = image.jpeg(.medium)
                let imageData1:NSData = imagessd as! NSData
                let strBase64:String = imageData1.base64EncodedString(options: .lineLength64Characters)
                 Size = Float(Double(imageData1.count)/1024/1024)
                
              //  let image : UIImage = imgUser.image!//UIImage(named:"imageNameHere")!
                       //Now use image to create into NSData format
//                       let imageData:NSData = image.pngData()! as NSData
//
//
                  //  Size = Float(Double(imageData.count)/1024/1024)
                if Int(Size) <= upload_limit
                    {
                        print("ImagesSize:-",Size)
                        ImagesSize = 0
                         base64 = strBase64
                        ViewImages.isHidden = false
                        viewHeightFileName.constant = 50
                        // Here your image
                    }
                else
                    {
                        ImagesSize = 1
                                //  self.showAlertWithCompletion(pTitle: "", pStrMessage: "Maximum images size 3 MB uploaded", completionBlock: nil)

                }
                
                                    
//                guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
//
//                          // return
//
//                       }
                        let timestamp = NSDate().timeIntervalSince1970

                         // print("File Name:-",fileUrl.lastPathComponent)
                           fileName = "\(timestamp)"//fileUrl.lastPathComponent
                lblFileName.text = "\(timestamp)"
                       lblFileName.numberOfLines = 0
                       lblFileName.sizeToFit()
                       btnUploaded.setImage(UIImage.init(named: "AttachementBlue"), for: .normal)

                strSelectOptionImages = 0

            }
        }
        else
        {
            // Gallery

            if let image = info[.originalImage] as? UIImage {
               // imgUser.image = image
              //  UserImagesSelected = image
                let imagessd = image.jpeg(.medium)
                let imageData1:NSData = imagessd as! NSData
                 Size = Float(Double(imageData1.count)/1024/1024)
                
              //  let image : UIImage = imgUser.image!//UIImage(named:"imageNameHere")!
                       //Now use image to create into NSData format
                       let imageData:NSData = image.pngData()! as NSData
                      let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
                
                    Size = Float(Double(imageData.count)/1024/1024)
                if Int(Size) <= upload_limit
                    {
                        print("ImagesSize:-",Size)
                        ImagesSize = 0
                         base64 = strBase64
                        ViewImages.isHidden = false
                        viewHeightFileName.constant = 50
                        // Here your image
                    }
                else
                    {
                        ImagesSize = 1
                                //  self.showAlertWithCompletion(pTitle: "", pStrMessage: "Maximum images size 3 MB uploaded", completionBlock: nil)

                }
                
                                    
                

                
            }
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                       
                       return
                       
                   }
                      print("File Name:-",fileUrl.lastPathComponent)
                       fileName = fileUrl.lastPathComponent
                   lblFileName.text = "\(fileName)"
                   lblFileName.numberOfLines = 0
                   lblFileName.sizeToFit()
                   btnUploaded.setImage(UIImage.init(named: "AttachementBlue"), for: .normal)
        }
        
        
        

        
       
        //ImagesUploadedAPI()
        //colMedia.reloadData()
       // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)

        self.dismiss(animated: true, completion: nil)
    }
    
   /* */
}
