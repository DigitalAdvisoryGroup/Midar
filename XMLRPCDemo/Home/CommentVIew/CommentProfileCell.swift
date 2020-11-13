//
//  CommentProfileCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 03/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser
import AVKit
import SKPhotoBrowser_Kingfisher

import AVFoundation
import MediaPlayer
import Cosmos
class CommentProfileCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var txtview : UITextView!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnDisLike : UIButton!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblname : UILabel!
    @IBOutlet var lbldate : UILabel!
    var objectDict = NSDictionary()
    var media_idsAry = [NSDictionary]()
    var indexPath : IndexPath!
    @IBOutlet var btncomment : UIButton!
    @IBOutlet var btndelete : UIButton!
    @IBOutlet var btnshare : UIButton!
    @IBOutlet var lblComment : UILabel!
    @IBOutlet var lbldesc : UILabel!
    var view = UIViewController()
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet var btnRating : UIButton!
    @IBOutlet var lblrating : UILabel!
    
    
    @IBOutlet var cvMedia : UICollectionView!
    @IBOutlet var cnCollectionHeight : NSLayoutConstraint!
    var btnLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    var btnDisLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvMedia.register(UINib(nibName: "MediaColCell", bundle: nil), forCellWithReuseIdentifier: "MediaColCell")
        
        self.cvMedia.register(UINib(nibName: "PdfViewCell", bundle: nil), forCellWithReuseIdentifier: "PdfViewCell")
        self.cvMedia.dataSource = self
        self.cvMedia.delegate = self
        
        // Initialization code
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,object : NSDictionary)
    {
        indexPath = indexPath1
        objectDict = object
        lblname.text = "\(object["name"] ?? "")"
        let datestr = "\(object.object(forKey: "date") as! String) "
        let isoDate = "\(datestr)"
        
        let dateFormatter = DateFormatter()
        //  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let date = dateFormatter.date(from:isoDate)!
        
        //dateDD.MM HH:MM
        let timeAgo:String = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        
        
        lbldate.text = "Published by ".localized() + "\(object["post_owner"] ?? "") " + "\(timeAgo) "
        lbldate.numberOfLines = 0
        lbldate.sizeToFit()
        
        //"Publiched by BIT \(object["date"] ?? "")"
        lblrating.text = "\(object["rating"] ?? 0)"
        
        viewRating.settings.fillMode = .precise
        viewRating.rating = (object["rating"] as? Double)!
        txtview.isEditable = false
        txtview.dataDetectorTypes = .all
        //
        txtview.text = "\(object["message"] ?? "")"
        adjustUITextViewHeight(arg: txtview)
        txtview.translatesAutoresizingMaskIntoConstraints = false
        //        lbldesc.text = "\(object["message"] ?? "")"
        //        lbldesc.numberOfLines = 0
        //       // lbldesc.dataDetectorTypes = .all
        //        lbldesc.sizeToFit()
        let commentary = object.object(forKey: "comments") as! NSArray
        lblComment.text = "\(commentary.count) " + "Comments".localized()
        let likedata = object.object(forKey: "like") as? Int
        if likedata == 0
        {
            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
            
        }
        else
        {
            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
            
        }
        let Dislikedata = objectDict.object(forKey: "dislike") as? Int
        if Dislikedata == 0
        {
            btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)
           
        }
        else
        {
            btnDisLike.setImage(UIImage.init(named: "DisLikeFiled"), for: .normal)
           
        }
        
        // Like & Dislike Logic
        if likedata == 0 && Dislikedata == 0
        {
            btnLike.isUserInteractionEnabled = true
            btnDisLike.isUserInteractionEnabled = true
            
        }
        let total_dislike_count = objectDict.object(forKey: "total_dislike_count") as? Int
        let total_like_count = objectDict.object(forKey: "total_like_count") as? Int
        let total_share_count = objectDict.object(forKey: "total_share_count") as? Int
        btnLike.setTitle("  \(total_like_count!)", for: .normal)
        btnDisLike.setTitle("  \(total_dislike_count!)", for: .normal)
        btnshare.setTitle("  \(total_share_count!)", for: .normal)
       
        let imgesUrl = object["image"] as? String
        let IMagesURl = imgesUrl!.removeWhitespace()
       
        self.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
        
      
        if media_idsAry.count == 0
        {
            self.setCollectionHeight(0)
        }else
        {
            self.cvMedia.reloadData()
            
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
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: Button Action
    @IBAction func LikeUnlikeAction(_ sender: Any)
    {
        
        let likedata = objectDict.object(forKey: "like") as? Int
        if likedata == 0
        {
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
           
            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
            btnDisLike.isUserInteractionEnabled = false
            
        }
        else
        {
            btnDisLike.isUserInteractionEnabled = true
            
            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
        }
       
        self.btnLikeCallBack?(self.indexPath,likedata!)
        
        
        
    }
    
    @IBAction func btnDisLikeTapped(_ sender : UIButton){
        
        let likedata = objectDict.object(forKey: "dislike") as? Int
        if likedata == 0
        {
            btnLike.isUserInteractionEnabled = false
            
            btnDisLike.setImage(UIImage.init(named: "DisLikeFiled"), for: .normal)
            
        }
        else
        {
            btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)
            
            btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)
            
           
        }
        
        
        self.btnDisLikeCallBack?(self.indexPath,likedata!)
    }
    
    //MARK: CollectionView Delegate Method
    
    func setCollectionHeight(_ height : CGFloat){
        print("================== total img:  === Heeight :\(height)")
        self.cnCollectionHeight.constant = height
        self.layoutIfNeeded()
        self.updateConstraints()
    }
    //MARK:- collection methods
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let cellDetails = self.objectDict.object(forKey: "media_ids") as? NSArray
        
        //socialPostDetails.socialMedias[indexPath.row]
        let socialMedias = self.objectDict.object(forKey: "media_ids") as? NSArray
        //self.socialPostDetails.socialMedias
        
        if socialMedias?.count == 0{
            self.setCollectionHeight(0)
            return CGSize.zero
        }else if socialMedias?.count == 1{
            let socialMediasDict = socialMedias?[indexPath.row] as? NSDictionary
            
            let type = socialMediasDict?.object(forKey: "mimetype") as? String
            
            if type == "pdf"
            {
                //Pdf
               
                self.setCollectionHeight(100)
                self.layoutIfNeeded()
                return CGSize(width: self.frame.size.width, height: 100)
            }
            else
            {
                
               
                
                if type == "image"
                {
                    let  height = socialMediasDict?.object(forKey: "height") ?? 0
                    let  width = socialMediasDict?.object(forKey: "width") ?? 0
                    let heightF = CGFloat(integerLiteral: height as! Int)
                    let widthF = CGFloat(integerLiteral: width as! Int)
                    //Float(height)
                    //  let widthF = Float(width)
                    let newHeightRatio = collectionView.frame.size.width / CGFloat(widthF)
                    let newHeight = CGFloat(heightF) * newHeightRatio
                    self.setCollectionHeight(newHeight)
                    self.layoutIfNeeded()
                    return CGSize(width: self.frame.size.width, height: newHeight)
                }else
                {
                    let newHeightRatio = collectionView.frame.size.width / CGFloat(80)
                   
                    let newHeight = CGFloat(30) * newHeightRatio
                    
                    self.setCollectionHeight(newHeight)
                    self.layoutIfNeeded()
                    return CGSize(width: self.frame.size.width, height: newHeight)
                    
                }
                
            }
            
            
        }else if socialMedias?.count == 2{
            let socialMediasDict = socialMedias?[indexPath.row] as? NSDictionary
            
            var type = socialMediasDict?.object(forKey: "mimetype") as? String
            
            if type == "pdf"
            {
               
                self.setCollectionHeight(cvMedia.frame.size.width / 2)
               
            
                return CGSize(width: cvMedia.frame.size.width, height: cvMedia.frame.size.height / 2)
            }
            else
            {
                self.setCollectionHeight(cvMedia.frame.size.width / 2)
               
                return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height)
            }
            
        }
        else if socialMedias?.count == 3{
            self.setCollectionHeight(cvMedia.frame.size.width / 2)
            
          
            if indexPath.row == 0
            {
                return CGSize(width: cvMedia.frame.size.width , height: cvMedia.frame.size.height / 2 )
                
            }
            else
            {
                return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height / 2)
                
            }
        }
        else if socialMedias!.count >= 3{
            //            let totalHeight = ceil(Double(socialMedias!.count) / 2) * Double((self.frame.size.width / 2))
            //            self.setCollectionHeight(CGFloat(437))
            self.setCollectionHeight(cvMedia.frame.size.width)
           
          
            if indexPath.row + 1 >= 5{
                // return CGSize.zero
                return CGSize(width: 0, height: 0)
            }
            
            print("cvMedia.frame.size.height:-",cvMedia.frame.size.height)
           
            return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height / 4 )
            
           
        }
        else{
            self.setCollectionHeight(0)
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media_idsAry.count//self.socialPostDetails.socialMedias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaColCell", for: indexPath) as! MediaColCell
        cvMedia.isUserInteractionEnabled = true
        let socialMedias = media_idsAry[indexPath.row]//self.socialPostDetails.socialMedias
        if media_idsAry.count > 0{
            
            let type = socialMedias.object(forKey: "mimetype") as? String
            
            switch type {
            case "image":
                cell.configureCellWith(socialMedias, media_idsAry: media_idsAry, IndexPath: indexPath)
                
            case "video":
                cell.configureSingleVideo(socialMedias, index: indexPath)
            case "pdf":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PdfViewCell", for: indexPath) as! PdfViewCell
                
                //let urlstr =
                let urlstr = socialMedias.object(forKey: "url") as? String
                // let str = urlstr.lastp
                let theURL = URL(string: urlstr!)  //use your URL
                let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
                cell.lblName.text = "\(fileNameWithExt ?? "")"
                
                return cell
               
            default:
                break
            }
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DidSelect CollectionView Cell")
        let socialMedias = media_idsAry[indexPath.row]
        let type = socialMedias.object(forKey: "mimetype") as? String
        switch type {
        case "image":
            // cell.configureCellWith(socialMedias)
          
            
            
              var images = [KFPhoto]()
              
                      
                        for i in 0..<media_idsAry.count
                        {
                            let dict = media_idsAry[i] //as! NSDictionary
                            let imgesUrl = dict.object(forKey: "url") as? String
                            let IMagesURl = imgesUrl!.removeWhitespace()

                                let holder = ImageCache.default.retrieveImageInDiskCache(forKey: IMagesURl)
                                          let photo = KFPhoto(url: IMagesURl, holder: holder)
                                          images.append(photo)
                           
                        }
                       

            
            
            /*var images = [SKPhoto]()
            // SKPhotoBrowserOptions.displayAction = false
            
            for i in 0..<media_idsAry.count
            {
                let dict = media_idsAry[i] as! NSDictionary
                let imgesUrl = dict.object(forKey: "url") as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                let photo = SKPhoto.photoWithImageURL(IMagesURl)
                // photo.shouldCachePhotoURLImage = true
                
                images.append(photo)
                // print("i:-",i)
            }
            */
            
            let browser = SKPhotoBrowser(photos: images)
            //browser.updateCloseButton(#imageLiteral(resourceName: "backArrow"))
            browser.initializePageIndex(indexPath.row)
            SKPhotoBrowserOptions.displayAction = true
            
            UIApplication.topViewController()?.present(browser, animated: true, completion: {})
            
        case "video":
            
            NotificationCenter.default.post(name: NSNotification.Name("VideoClick"), object: nil,userInfo: nil)
            // if let videoURL = URL(string: "https://bit.runbot.candidroot.com/web/image/722")
            //
            
            if let videoURL = URL(string: (socialMedias.object(forKey: "url") as? String)!)
            {
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                UIApplication.topViewController()?.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
                
            }
        case "pdf":
            let urlstr = socialMedias.object(forKey: "url") as? String
            let IMagesURl = urlstr!.removeWhitespace()
            let theURL = URL(string: IMagesURl)  //use your URL
            
            
            
            let playerViewController = webviewClass()
            playerViewController.str = IMagesURl
            // playerViewController.fileURLs = urlNS!
            UIApplication.topViewController()?.show(playerViewController, sender: nil)
            
            
            
            break
            
            
        default:
            break
        }
        
        
    }
}
