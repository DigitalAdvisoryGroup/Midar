//
//  CommentListCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 03/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
//import Alamofire
import DropDown
import SKPhotoBrowser

class CommentListCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet var imgCommentUser : UIImageView!
     @IBOutlet var imgCommentUserImages : UIImageView!
    @IBOutlet var cnImagesViewHeight : NSLayoutConstraint!
    @IBOutlet var lblCommentName : UILabel!
     @IBOutlet var lbldate : UILabel!
    @IBOutlet var lblCommentDes : UILabel!
    @IBOutlet var btnDeletedView : UIButton!
    @IBOutlet var btnDeleted : UIButton!
      var CommentRlyAry = [NSDictionary]()
    var indexPath : IndexPath!
    let DeleteDropDown = DropDown()
     
     @IBOutlet var ViewPDF : UIView!
     @IBOutlet var lblPdfName : UILabel!
    
    var objectDict = NSDictionary()
     @IBOutlet var cvMedia : UICollectionView!
    @IBOutlet var btnLike : UIButton!
         @IBOutlet var btnDisLike : UIButton!
      @IBOutlet var btnreplay : UIButton!
     @IBOutlet var cnCollectionHeight : NSLayoutConstraint!
    var ViewObje = UIViewController()
    var btnLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
        var btnDisLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
       var isExpanded = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvMedia.register(UINib(nibName: "CommentChildCell", bundle: nil), forCellWithReuseIdentifier: "CommentChildCell")
               self.cvMedia.dataSource = self
               self.cvMedia.delegate = self
        // Initialization code
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,object : NSDictionary)
    {
        ViewObje = viewController
        CommentRlyAry  = object.object(forKey: "child_comments") as! [NSDictionary]
        indexPath = indexPath1
        
        let likedata = object.object(forKey: "comment_like") as? Int
        let like_counter = object.object(forKey: "like_counter") as? Int
        let dislike_counter = object.object(forKey: "dislike_counter") as? Int
        let replay_counter = object.object(forKey: "replay_counter") as? Int
        btnLike.setTitle("  \(like_counter!)", for: .normal)
        btnDisLike.setTitle("  \(dislike_counter!)", for: .normal)
        btnreplay.setTitle("  \(replay_counter!)", for: .normal)
        if likedata == 0
        {
            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
           
        }
        else
        {
            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
           
        }
        let Dislikedata = objectDict.object(forKey: "comment_dislike") as? Int
        if Dislikedata == 0
        {
            btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)
        
        }
        else
        {
            btnDisLike.setImage(UIImage.init(named: "DisLikeFiled"), for: .normal)
        
        }
       let datestr = "\(object.object(forKey: "date") as! String) "
        let isoDate = "\(datestr)"

        let dateFormatter = DateFormatter()
      //  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        let date = dateFormatter.date(from:isoDate)!
       
        //dateDD.MM HH:MM
        let timeAgo:String = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        print("Hours:- \(timeAgo) ")
        lbldate.text = "\(timeAgo) "//"\(datestr)"
        // Ex- 1 hour ago
        let name = "\(object.object(forKey: "author_name") as! String) " + "\(object.object(forKey: "date") as! String)"
        lblCommentName.text = "\(object.object(forKey: "author_name") as! String) "
        //"\(object.object(forKey: "author_name") as! String)"
        lblCommentDes.text = "\(object.object(forKey: "comment") as! String)"
        //"Test For ios sdjskdj sjdksjdkj ksdjksjkdjk jjsjskjdks jsdkjskdj jkjsdj jkskjdksjdksjdksjdkskjdksjdkj sjdkjsdkjksj jkjskdjskdj kjksj jksjdksdkjsd "//"\(object.object(forKey: "comment") as! String)"
        lblCommentDes.numberOfLines = 0
        lblCommentDes.sizeToFit()
        
        btnDeletedView.tag = indexPath.row
        DeleteDropDown.tag = btnDeletedView.tag
        DeleteDropDown.anchorView = btnDeletedView
        DeleteDropDown.bottomOffset = CGPoint(x: 0, y: btnDeletedView.bounds.height)
        
        DeleteDropDown.dataSource = [
            "Delete Comment"
        ]
        
        let imgesUrl = object.object(forKey: "author_image") as? String
                       let IMagesURl = imgesUrl!.removeWhitespace()
      
        self.imgCommentUser.kf.setImage(with: URL.init(string: IMagesURl))

//
        //partner_id
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        
        if let parID = object.object(forKey: "partner_id") as? Int
        {
            if parther_ID == parID
            {
                btnDeleted.isHidden = false
                btnDeletedView.isHidden = false
                
            }
            else
            {
                btnDeleted.isHidden = true
                               btnDeletedView.isHidden = true
                               
            }
        }
        if CommentRlyAry.count == 0
        {
              self.setCollectionHeight(0)
        }
        else
        {
            self.setCollectionHeight(70)
        }
        self.cvMedia.reloadData()
        
    }
    @IBAction func DeleteComment(_ sender: AnyObject) {
        DeleteDropDown.show()
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    @IBAction func btnLikeTapped(_ sender : UIButton){
        
        let likedata = objectDict.object(forKey: "comment_like") as? Int
        if likedata == 0
        {
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }

            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
            
        }
        else
        {

            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
        }
       
        self.btnLikeCallBack?(self.indexPath,likedata!)
    }

        @IBAction func btnDisLikeTapped(_ sender : UIButton){
            //  let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like
            
            let likedata = objectDict.object(forKey: "comment_dislike") as? Int
            if likedata == 0
            {
                  btnDisLike.setImage(UIImage.init(named: "DisLikeFiled"), for: .normal)
            
            }
            else
            {
              btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)

             
            }
            
            
   
            self.btnDisLikeCallBack?(self.indexPath,likedata!)
        }
    
   //MARK: CollectionView Method
    func setCollectionHeight(_ height : CGFloat){
           print("================== total img:  === Heeight :\(height)")
           self.cnCollectionHeight.constant = height
           //self.layoutIfNeeded()
           self.updateConstraints()
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        
        
        var media_idsAry = [NSDictionary]()
                
        let socialMedias = CommentRlyAry[indexPath.row]
         media_idsAry = socialMedias.object(forKey: "media_ids") as! [NSDictionary]
        
       
            let desc = "\(socialMedias.object(forKey: "comment") as! String)"
                       let desHeight = desc.height(forConstrainedWidth: 210.0, font: UIFont.systemFont(ofSize: 15.0))
                       let valueHeight  =  70
                                        self.setCollectionHeight(CGFloat(valueHeight))
                       self.layoutIfNeeded()
                        return CGSize(width: self.cvMedia.frame.size.width, height: desHeight + 70 + 135)
                                        //self.setCollectionHeight(70)
                                                      
    
       
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CommentRlyAry.count//media_idsAry.count//self.socialPostDetails.socialMedias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentChildCell", for: indexPath) as! CommentChildCell
        
        
        cell.configureCellWith(indexPath1: indexPath)
        let socialMedias = CommentRlyAry[indexPath.row]
        cell.btnShowmore.tag = indexPath.row
        
        
        cell.imgCommentUser.tag = indexPath.row
        let tapImagesUser = UITapGestureRecognizer(target: self, action: #selector(self.handleCommentUserImages))
        cell.imgCommentUser.addGestureRecognizer(tapImagesUser)
        
        cell.lblCommentName.tag = indexPath.row
        let tapCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handleCommentCommentname))
        cell.lblCommentName.addGestureRecognizer(tapCommentUser)
        
        //btn deleted
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        
        if let parID = socialMedias.object(forKey: "partner_id") as? Int
        {
            if parther_ID == parID
            {
                cell.btnDeleted.isHidden = false
                cell.btnDeletedView.isHidden = false
                
            }
            else
            {
                cell.btnDeleted.isHidden = true
                cell.btnDeletedView.isHidden = true
                
            }
        }
        
        cell.btnDeletedView.tag = indexPath.row
        cell.DeleteRlyDropDown.tag = cell.btnDeletedView.tag
        cell.DeleteRlyDropDown.anchorView = cell.btnDeletedView
        cell.DeleteRlyDropDown.bottomOffset = CGPoint(x: 0, y: cell.btnDeletedView.bounds.height)
        
        cell.DeleteRlyDropDown.dataSource = [
            "Delete Comment"
        ]
        
        cell.DeleteRlyDropDown.selectionAction = { [weak self] (index, item) in
            
            print("DeletedCOmmentAPi",cell.DeleteRlyDropDown.tag)
            //print("index:-",index)
            //print("self?.CommentAry:-",self?.CommentAry)
            let dataDict = self?.CommentRlyAry[indexPath.row] as! NSDictionary
            let id = dataDict.object(forKey: "id") as! Int
            print("Comment ID:-",id)
            self?.CommentRlyAry.remove(at: indexPath.row)
            self?.cvMedia?.reloadData()
            self?.DeleteCommentAPI(CommentID: id)
            //APi
        }
        
        
        cell.lblCommentName.text = "\(socialMedias.object(forKey: "author_name") as! String) "
        //"\(object.object(forKey: "author_name") as! String)"
        cell.lblCommentDes.text = "\(socialMedias.object(forKey: "comment") as! String)"
        cell.lblCommentDes.numberOfLines = 0
        cell.lblCommentDes.sizeToFit()
        let datestr = "\(socialMedias.object(forKey: "date") as! String) "
        let isoDate = "\(datestr)"
        
        let dateFormatter = DateFormatter()
        //  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from:isoDate)!
        
        //date
        let timeAgo:String = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        print("Hours:- \(timeAgo)")
        cell.lbldate.text = "\(timeAgo) "//"\(datestr)"
        let imgesUrl = socialMedias.object(forKey: "author_image") as? String
        let IMagesURl = imgesUrl!.removeWhitespace()
        let fileUrl = URL(string: IMagesURl)
         cell.imgCommentUser.kf.setImage(with: URL.init(string: IMagesURl))
        

        if CommentRlyAry.count == 1
        {
            cell.imgDownArrow.isHidden = true
        }
        else
        {
            cell.imgDownArrow.isHidden = false
        }
        
        
        // View Show
        
        var media_idsAry = [NSDictionary]()
        
        
        
        // let socialMedias = CommentRlyAry[indexPath.row]
        media_idsAry = socialMedias.object(forKey: "media_ids") as! [NSDictionary]
        if media_idsAry.count == 0
        {
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
                cell.ViewPDF.tag = indexPath.row
                let tapImagesCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handlePdfViewOpen))
                cell.ViewPDF.addGestureRecognizer(tapImagesCommentUser)
                cell.ViewPDF.isUserInteractionEnabled = true
                
            }
            else
            {
                cell.ViewPDF.isHidden = true
                cell.imgCommentUserImages.tag = indexPath.row
                let tapImagesCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handleImagesViewOpen))
                cell.imgCommentUserImages.addGestureRecognizer(tapImagesCommentUser)
                cell.imgCommentUserImages.isUserInteractionEnabled = true
                let imgesUrl = dict!.object(forKey: "url") as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                let fileUrl = URL(string: IMagesURl)
                 cell.imgCommentUserImages.kf.setImage(with: URL.init(string: IMagesURl))
                

            }
            
            
            
            
        }
        //cell.layoutIfNeeded()
        
        return cell
    }
    
    @objc func handleCommentUserImages(_ sender: UITapGestureRecognizer? = nil) {
                   // handling code
                  
           let tag = sender?.view?.tag
           print("handleCommentUserImages:-",tag)
           let  object = CommentRlyAry[tag!] as! NSDictionary
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
              let  object = CommentRlyAry[tag!] as! NSDictionary
               let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                     homevc.partner_idINt = object.object(forKey: "partner_id") as! Int
                      homevc.ProfileFlag = "1"
           
           UIApplication.topViewController()?.show(homevc, sender: nil)
                     //self.navigationController?.pushViewController(homevc, animated: true)
          }
    // comment Images
    
    @objc func handleImagesViewOpen(_ sender: UITapGestureRecognizer? = nil) {
                  // handling code
                 
          let tag = sender?.view?.tag
       //   print("handleCommentUserImages:-",tag)
          let  object = CommentRlyAry[tag!] as! NSDictionary
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
    @objc func handlePdfViewOpen(_ sender: UITapGestureRecognizer? = nil) {
                    // handling code
                   
        let tag = sender?.view?.tag
        let  object = CommentRlyAry[tag!] as! NSDictionary
               var media_idsAry = [NSDictionary]()
                    media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
        let dict = media_idsAry[0] as? NSDictionary
        
        let urlstr = dict!.object(forKey: "url") as? String
         let IMagesURl = urlstr!.removeWhitespace()
      
                   
        let playerViewController = webviewClass()
        playerViewController.str = IMagesURl
        // playerViewController.fileURLs = urlNS!
        UIApplication.topViewController()?.show(playerViewController, sender: nil)
    }
    func DeleteCommentAPI(CommentID: Int)  {
        let uid = UserDefaults.standard.object(forKey: "uid")
//        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
//        let PostId =  objectDict.object(forKey: "id") as! Int
//
        //let jsonreuest: [String: Any] = ["post_id": "\(PostId)","partner_id":"\(parther_ID)","comment":"\(textView.text!)"]
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","unlink",[CommentID]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.ViewObje.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            
            let data = ObejcData as? Bool
            
            if data == true
            {
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("LikeUnlike"), object: nil,userInfo: nil)
                  //  self.tblCommentPost.reloadData()
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
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
