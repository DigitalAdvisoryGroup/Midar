//
//  SocialPostTableViewCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 02/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser
import AVKit
import Alamofire
import SKPhotoBrowser_Kingfisher
//import Alamofire
import AVFoundation
import MediaPlayer
import Cosmos
import PDFReader
import MBProgressHUD
class SocialPostTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet var btnRating : UIButton!
    @IBOutlet var lblrating : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnDisLike : UIButton!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblname : UILabel!
    @IBOutlet var lbldate : UILabel!
    @IBOutlet var imgCommentUser : UIImageView!
    @IBOutlet var lblCommentName : UILabel!
    @IBOutlet var lblCommentDes : UILabel!
    @IBOutlet var lblCommentsCount : UILabel!
    @IBOutlet var txtview : UITextView!
    
    var objectDict = NSDictionary()
    var media_idsAry = [NSDictionary]()
    var indexPath : IndexPath!
    @IBOutlet var btncomment : UIButton!
    @IBOutlet var btndelete : UIButton!
    @IBOutlet var btnshare : UIButton!
    var btnDeleteCallBack: (( _ indexPath : IndexPath)->())?
    
    var btnLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    var btnDisLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    
    // @IBOutlet weak var txtView: ReadMoreTextView!
    @IBOutlet var cnCollectionHeight : NSLayoutConstraint!
    @IBOutlet var CommentViewBottom : NSLayoutConstraint!
    
    @IBOutlet var txtViewHeight : NSLayoutConstraint!
    @IBOutlet var CommentView : UIView!
    
    
    @IBOutlet var cvMedia : UICollectionView!
    
    var ViewController = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cvMedia.register(UINib(nibName: "MediaColCell", bundle: nil), forCellWithReuseIdentifier: "MediaColCell")
        
        self.cvMedia.register(UINib(nibName: "PdfViewCell", bundle: nil), forCellWithReuseIdentifier: "PdfViewCell")
        self.cvMedia.dataSource = self
        self.cvMedia.delegate = self
    }
    func attributedKeyValue(key : String, value : String) -> NSAttributedString{
        return NSAttributedString().appendAttributeString(["\(key)"], keyFont: UIFont.boldSystemFont(ofSize: 13), keyColor: .black, valueStrings: ["\(value)"], valueFont: UIFont.systemFont(ofSize: 10), valueColor: .blue)
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,value: Int,object : NSDictionary)
    {
        ViewController = viewController
        indexPath = indexPath1
        lblname.text = "\(object["name"] ?? "")"
        
        
        let datestr = "\(object.object(forKey: "date") ?? "") "
        let isoDate = "\(datestr)"
        
        let dateFormatter = DateFormatter()
        //  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
         let date = dateFormatter.date(from:isoDate)
        
        //dateDD.MM HH:MM
        let timeAgo:String = timeAgoSinceDate(date!, currentDate: Date(), numericDates: true)
        
        lbldate.text = "Published by ".localized() + "\(object["post_owner"] ?? "") " + "\(timeAgo) "
        lbldate.numberOfLines = 0
        lbldate.sizeToFit()
        
        lblrating.text = "\(object["rating"] ?? 0)"
        
        viewRating.settings.fillMode = .precise
        viewRating.rating = (object["rating"] as? Double)!
        
        
        txtview.isEditable = false
        txtview.dataDetectorTypes = .all
        
        //
        let strmsg = "\(object["message"] ?? "")"
        txtview.text = strmsg
       // txtview.attributedText = strmsg.attributedHtmlString//attributedStringForPairedLabel(titleColor: UIColor.black, infoColor: UIColor.black)
        //"\(object["message"] ?? "")"
        if strmsg.count <= 45
        {
            //Height Const
            
            txtViewHeight.isActive = true
        }
        else
        {
            txtViewHeight.isActive = false
            
            
            
        }
        
        
        
        adjustUITextViewHeight(arg: txtview)
        txtview.translatesAutoresizingMaskIntoConstraints = false
        
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
        //let total_comment_count = objectDict.object(forKey: "total_comment_count") as? Int
        let total_dislike_count = objectDict.object(forKey: "total_dislike_count") as? Int
        let total_like_count = objectDict.object(forKey: "total_like_count") as? Int
        let total_share_count = objectDict.object(forKey: "total_share_count") as? Int
        btnLike.setTitle("  \(total_like_count!)", for: .normal)
        btnDisLike.setTitle("  \(total_dislike_count!)", for: .normal)
        btnshare.setTitle("  \(total_share_count!)", for: .normal)
        
        
        if let commentary = object.object(forKey: "comments") as? NSArray
        {
            lblCommentsCount.text = "\(commentary.count) " + "Comments".localized()
            
            
        }
        
        
        self.cvMedia.reloadData()
        
        
        
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
    func formatTextInTextView(textView: UITextView) {
        textView.isScrollEnabled = false
        let selectedRange = textView.selectedRange
        let text = textView.text
        
        // This will give me an attributedString with the base text-style
        let attributedString = NSMutableAttributedString(string: text!)
        
        let regex = try? NSRegularExpression(pattern: "#(\\w+)", options: [])
        let matches = regex!.matches(in: text!, options: [], range: NSMakeRange(0, text!.count))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: matchRange)
        }
        
        textView.attributedText = attributedString
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.selectedRange = selectedRange
        textView.isScrollEnabled = true
    }
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
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
    @IBAction func btnLikeTapped(_ sender : UIButton){
        //  let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like
        
        let likedata = objectDict.object(forKey: "like") as? Int
        if likedata == 0
        {
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
            //  btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)
            
            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
            btnDisLike.isUserInteractionEnabled = false
        }
        else
        {
            // btnDisLike.setImage(UIImage.init(named: "DisLikeFiled"), for: .normal)
            btnDisLike.isUserInteractionEnabled = true
            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
        }
        // let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like
        //self.btnLikeCallBack?(self.socialPostDetails, E_LikeReaction.init(rawValue: self.socialPostDetails.myLike)!, likeOrNone, self.indexPath)
        self.btnLikeCallBack?(self.indexPath,likedata!)
    }
    
    @IBAction func btnDisLikeTapped(_ sender : UIButton){
        //  let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like
        
        let likedata = objectDict.object(forKey: "dislike") as? Int
        if likedata == 0
        {
            btnLike.isUserInteractionEnabled = false
            
            btnDisLike.setImage(UIImage.init(named: "DisLikeFiled"), for: .normal)
            
        }
        else
        {
            btnDisLike.setImage(UIImage.init(named: "DisLike"), for: .normal)
            btnLike.isUserInteractionEnabled = true
            
            
        }
        
        
        self.btnDisLikeCallBack?(self.indexPath,likedata!)
    }
    
    @IBAction func btnDeleteTapped(_ sender : UIButton){
        
        self.btnDeleteCallBack?(self.indexPath)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
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
              //  self.layoutIfNeeded()
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
                    
                    //cvMedia.frame.origin.y = txtview.frame.size.height + txtview.frame.origin.y + 8
                    let newHeightRatio = collectionView.frame.size.width / CGFloat(widthF)
                    let newHeight = CGFloat(heightF) * newHeightRatio
                    self.setCollectionHeight(newHeight)
                   // self.layoutIfNeeded()
                    return CGSize(width: self.frame.size.width, height: newHeight)
                }else
                {
                    let newHeightRatio = collectionView.frame.size.width / CGFloat(80)
                    //CGFloat(cellDetails.width)
                    //let newHeight = CGFloat(cellDetails.height) * newHeightRatio
                    let newHeight = CGFloat(30) * newHeightRatio
                    
                   // self.setCollectionHeight(collectionView.frame.size.width)
                    self.setCollectionHeight(newHeight)
                  //  self.layoutIfNeeded()
                    return CGSize(width: self.frame.size.width, height: newHeight)
                    
                }
                
            }
            
            
        }else if socialMedias?.count == 2{
            let socialMediasDict = socialMedias?[indexPath.row] as? NSDictionary
            
            let type = socialMediasDict?.object(forKey: "mimetype") as? String
            
            if type == "pdf"
            {
                self.setCollectionHeight(cvMedia.frame.size.width / 2)
                //self.layoutIfNeeded()
           
                return CGSize(width: cvMedia.frame.size.width, height: cvMedia.frame.size.height / 2)
            }
            else
            {
                self.setCollectionHeight(cvMedia.frame.size.width / 2)
                //self.layoutIfNeeded()
              
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
            
            
          
            self.setCollectionHeight(cvMedia.frame.size.width)
            
            if indexPath.row + 1 >= 5{
                return CGSize(width: 0, height: 0)
            }
            else
            {
                
                return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height / 4 )
            }
            
            
            
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
        
        let socialMedias = media_idsAry[indexPath.row]//self.socialPostDetails.socialMedias
        if media_idsAry.count > 0{
            
            let type = socialMedias.object(forKey: "mimetype") as? String
            
            switch type {
            case "image":
                // cell.configureCellWith(socialMedias)
                cell.configureCellWith(socialMedias, media_idsAry: media_idsAry, IndexPath: indexPath)
                
            case "video":
                cell.configureSingleVideo(socialMedias, index: indexPath)
                
              // cell.AVPLAYER?.pause()
            case "pdf":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PdfViewCell", for: indexPath) as! PdfViewCell
                
                //let urlstr =
                let urlstr = socialMedias.object(forKey: "url") as? String
                let IMagesURl = urlstr!.removeWhitespace()
                
                // let str = urlstr.lastp
                let theURL = URL(string: IMagesURl)  //use your URL
                let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
                cell.lblName.text = "\(fileNameWithExt ?? "")"
              
                return cell
                //break
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
           
        
          var images = [KFPhoto]()
         
//
          
          
            for i in 0..<media_idsAry.count
            {
                let dict = media_idsAry[i] //as! NSDictionary
                let imgesUrl = dict.object(forKey: "url") as? String
                let IMagesURl = imgesUrl!.removeWhitespace()

                    let holder = ImageCache.default.retrieveImageInDiskCache(forKey: IMagesURl)
                              let photo = KFPhoto(url: IMagesURl, holder: holder)
                              images.append(photo)
               
            }
           
            
           
            let browser = SKPhotoBrowser(photos: images)
            SKPhotoBrowserOptions.displayAction = true
            
            //browser.updateCloseButton(#imageLiteral(resourceName: "backArrow"))
            browser.initializePageIndex(indexPath.row)
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
            //            DispatchQueue.main.async {
            //                       MBProgressHUD.showAdded(to: self, animated: true)
            //                   }
            let urlstr = socialMedias.object(forKey: "url") as? String
            let IMagesURl = urlstr!.removeWhitespace()
            
            
            
            let playerViewController = webviewClass()
            playerViewController.str = IMagesURl
            // playerViewController.fileURLs = urlNS!
            UIApplication.topViewController()?.show(playerViewController, sender: nil)
            
            break
            
            
        default:
            break
        }
        
        
    }
    private func document(_ remoteURL: URL) -> PDFDocument? {
        return PDFDocument(url: remoteURL)
    }
    
    
    /// Add `thumbnailsEnabled:false` to `createNew` to not load the thumbnails in the controller.
    private func showDocument(_ document: PDFDocument,str:String) {
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
        
        UIApplication.topViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)
        //  UIApplication.topViewController()?.title = "\(str )"
        controller.title = "\(str )"
        controller.scrollDirection = .vertical
        //        controller.scree
        UIApplication.topViewController()?.show(controller, sender: true)
        
        
    }
   
    
    
    
}
extension SocialPostTableViewCell:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
    }
}


